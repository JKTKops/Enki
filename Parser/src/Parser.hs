{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FlexibleContexts #-}

module Parser where

import Control.Monad.IO.Class

import Data.List
import Data.Maybe

import System.Directory
import System.Environment
import System.FilePath.Posix

import Text.Parsec
import Text.Parsec.Expr

import Util

type Parser a = forall s st m. Stream s m Char => ParsecT s st m a

data Id = S String
        | I Integer
        | B Bool
        | V String
        | Comp [Id]
    deriving (Eq, Show)

data Expr = Expr Id
    deriving (Eq, Show)

data Constraint = Constraint Id
                | Constraints [Constraint]
                | When Constraint Constraint
    deriving (Eq, Show)

data Type = EnkiInt
          | EnkiBool
          | EnkiString
          | Any String
          | FuncType Type Type
          | RuleType Type Type
          | DataType Type Type
          | TypeName Id
    deriving (Eq, Show)

data Field = Field Id Type
    deriving (Eq, Show)

data Constructor = Constructor Id [Field]
    deriving (Eq, Show)

data Def = Func Id Constraint Expr
         | Rule Id Constraint
         | Data Id [Constructor]
         | Exec Constraint
         | Module String [Def]
         | NoImport String
    deriving (Eq, Show)

class PrettyPrint a where
    prettyPrint :: a -> String

maudeList :: [String] -> String
maudeList [] = "nil"
maudeList xs@(_:_) = unwords xs

instance PrettyPrint Id where
    prettyPrint (S str)      = "s(" ++ show str ++ ")"
    prettyPrint (I i)        = "i(" ++ show i ++ ")"
    prettyPrint (B b)        = "b(" ++ toLowerCase (show b) ++ ")"
    prettyPrint (V name)     = "v(" ++ show name ++ ")"
    prettyPrint (Comp parts) = "comp(" ++ maudeList (map prettyPrint parts) ++ ")"

instance PrettyPrint Expr where
    prettyPrint (Expr id) = "e(" ++ prettyPrint id ++ ")"

instance PrettyPrint Constraint where
    prettyPrint (Constraint id)       = "c(" ++ prettyPrint id ++ ")"
    prettyPrint (Constraints cs)      = "cs(" ++ maudeList (map prettyPrint cs) ++ ")"
    prettyPrint (When condition body) = "when(" ++ prettyPrint condition ++ "," ++ prettyPrint body ++ ")"

instance PrettyPrint Type where
    prettyPrint EnkiInt          = "int"
    prettyPrint EnkiBool         = "bool"
    prettyPrint EnkiString       = "string"
    prettyPrint (Any s)          = "any(\"" ++ s ++ "\")"
    prettyPrint (FuncType t1 t2) = "func(" ++ prettyPrint t1 ++ "," ++ prettyPrint t2 ++ ")"
    prettyPrint (RuleType t1 t2) = "rule(" ++ prettyPrint t1 ++ "," ++ prettyPrint t2 ++ ")"
    prettyPrint (DataType t1 t2) = "data(" ++ prettyPrint t1 ++ "," ++ prettyPrint t2 ++ ")"
    prettyPrint (TypeName id)    = "type(" ++ prettyPrint id ++ ")"

instance PrettyPrint Field where
    prettyPrint (Field id fieldType) = "field(" ++ prettyPrint id ++ "," ++ prettyPrint fieldType ++ ")"

instance PrettyPrint Constructor where
    prettyPrint (Constructor id fields) = "constructor(" ++ prettyPrint id ++ "," ++ maudeList (map prettyPrint fields) ++ ")"

instance PrettyPrint Def where
    prettyPrint (Func id c e) = "def(f(" ++ prettyPrint id ++ "," ++ prettyPrint c ++ "," ++ prettyPrint e ++ "))"
    prettyPrint (Rule id c)   = "def(r(" ++ prettyPrint id ++ "," ++ prettyPrint c ++ "))"
    prettyPrint (Data id constrs) = "def(d(" ++ prettyPrint id ++ "," ++ maudeList (map prettyPrint constrs) ++ "))"
    prettyPrint (Exec c)   = "exec(ex(" ++ prettyPrint c ++ "))"
    prettyPrint (Module _ defs) = "import(m(" ++ maudeList (map prettyPrint defs) ++ "))"

parseFile :: String -> Maybe String -> IO ()
parseFile fname output = do
    parsed <- parseFileAst fname

    let outputStr = intercalate "\n" $ map prettyPrint parsed

    case output of
        Nothing -> putStrLn outputStr
        Just file -> writeFile file outputStr

parseFileAst :: String -> IO [Def]
parseFileAst fname = do
    enkiPath <- getEnv "ENKI_PATH"

    -- Load the standard library
    stdLib <- withCurrentDirectory enkiPath (parseDef =<< readFile "base.enki")

    let dir = takeDirectory fname
    let base = takeFileName fname

    res <- withCurrentDirectory dir (parseDef =<< readFile base)

    case (stdLib, res) of
        (Left err, _) -> error $ show err
        (_, Left err) -> error $ show err
        (Right stdLibParsed, Right parsed) -> pure $ fixImports $ [Module "base" stdLibParsed] ++ parsed

fixImports :: [Def] -> [Def]
fixImports defs = filter (noIgnore (concatMap ignore defs)) defs
    where
        noIgnore _ (NoImport _) = False -- Remove all of these
        noIgnore ignoredNames (Module name _) = name `notElem` ignoredNames
        noIgnore _ _ = True

        ignore (NoImport name) = [name]
        ignore _ = []

parseDef :: MonadIO m => String -> m (Either ParseError [Def])
parseDef = runParserT enkiDef () ""

enkiDef :: (MonadIO m, Stream s m Char) => ParsecT s st m [Def]
enkiDef = many (try enkiImport <|>
                try noImport <|>
                try func <|>
                try rule <|>
                try dataDef <|>
                try exec)

noImport :: (MonadIO m, Stream s m Char) => ParsecT s st m Def
noImport = do
    symbol $ string "do"
    symbol $ string "not"
    symbol $ string "use"
    moduleName <- symbol $ many $ noneOf " .\n\r\t"
    symbol $ string "."
    optional newlines

    pure $ NoImport moduleName

enkiImport :: (MonadIO m, Stream s m Char) => ParsecT s st m Def
enkiImport = do
    symbol $ string "use"
    -- TODO: Allow defining multiple modules per file
    moduleName <- symbol $ many $ noneOf " .\n\r\t"
    file <- optionMaybe $ do
        symbol $ string "from"
        symbol $ many $ noneOf " .\n\r\t"
    symbol $ string "."
    optional newlines

    let filename =
            case file of
                Nothing -> moduleName ++ ".enki"
                Just name -> if ".enki" `isSuffixOf` name then name else name ++ ".enki"

    -- TODO: Make this search multiple paths
    defs <- liftIO $ parseFileAst filename
    pure $ Module moduleName defs

exec :: Parser Def
exec = do
    lineSep
    c <- constraint
    symbol $ char '.'
    lineSep

    pure $ Exec c

lineSep :: Parser ()
lineSep = do
    wsSkip
    optional newlines
    wsSkip

rule :: Parser Def
rule = do
    lineSep
    id <- enkiId ["if", "where"]
    lineSep
    choice $ map string ["if", "where"]
    lineSep
    c <- constraint
    lineSep
    char '.'

    pure $ Rule id c

funcResultVar = V "AUTOGENERATEDFUNCTIONRESULT"

func :: Parser Def
func = do
    id <- symbol $ enkiId ["is"]
    symbol $ string "is"
    constr <- symbol constraint
    symbol $ char '.'

    pure $ case constr of
        Constraint cid -> Func id (Constraints []) $ Expr cid
        Constraints cs | allWhenBranches cs ->
            Func id (Constraints (map makeResult cs)) $ Expr $ Comp [funcResultVar]

        Constraints cs ->
            let (Constraint cid) = last cs
            in Func id (Constraints (init cs)) $ Expr cid
        When _ _       -> error "Cannot have a function with only a when branch for it's body"

makeResult :: Constraint -> Constraint
makeResult (When cond (Constraints [])) = When (makeResult cond) $ Constraints []
makeResult (When cond body)             = When cond $ makeResult body
makeResult (Constraints cs)             =
    -- TODO: Handle other cases (if they exist?)
    case last cs of
        Constraint id -> Constraints $ init cs ++ [Constraint (Comp [funcResultVar, S "=", id])]
makeResult c@(Constraint id) = Constraint $ Comp [funcResultVar, S "=", id]

allWhenBranches :: [Constraint] -> Bool
allWhenBranches = all isWhen
    where
        isWhen (When _ _) = True
        isWhen _          = False

dataDef :: Parser Def
dataDef = do
    id <- symbol $ enkiId ["may", "be"]
    symbol $ string "may"
    symbol $ string "be"
    constructors <- many (symbol constructor)
    lineSep

    pure $ Data id constructors

constructor :: Parser Constructor
constructor = try constructorWithFields <|> try unitConstructor

unitConstructor :: Parser Constructor
unitConstructor = do
    id <- enkiId []
    symbol $ char '.'

    pure $ Constructor id []

constructorWithFields :: Parser Constructor
constructorWithFields = do
    id <- symbol $ enkiId ["has"]
    symbol $ string "has"
    fields <- sepBy1 field $ symbol $ string ","
    symbol $ char '.'
    pure $ Constructor id fields

field :: Parser Field
field = do
    id <- symbol $ baseEnkiId [":"]
    symbol $ string ":"
    t <- symbol enkiType

    pure $ Field id t

enkiType :: Parser Type
enkiType = do
    first <- singleEnkiType
    rest <- optionMaybe $ do
        sep <- try $ choice $ map (symbol . string) ["->", "~", "*"]
        second <- enkiType
        pure $ case sep of
            "->" -> (FuncType, second)
            "~"  -> (RuleType, second)
            "*"  -> (DataType, second)

    pure $ case rest of
        Nothing -> first
        Just (constr, second) -> constr first second

singleEnkiType :: Parser Type
singleEnkiType = choice $ map try [namedType "int" EnkiInt, namedType "bool" EnkiBool, namedType "string" EnkiString,
                                   parenType, dataTypeName]

dataTypeName :: Parser Type
dataTypeName = do
    id <- symbol $ baseEnkiId []
    pure $ case id of
        Comp [V s] -> Any s
        _ -> TypeName id

parenType :: Parser Type
parenType = between (symbol (string "(")) (symbol (string ")")) enkiType

namedType :: String -> Type -> Parser Type
namedType enkiTName enkiTConst = do
    symbol $ string enkiTName
    pure enkiTConst

connected :: String -> (Type -> Type -> Type) -> Parser Type
connected connector constr = foldl1 constr <$> sepBy1 enkiType (symbol (string connector))

expr :: Parser Expr
expr = Expr <$> enkiId []

constraint :: Parser Constraint
constraint = Constraints <$> (try (sepBy1 (try when <|> try otherwiseBranch) lineSep) <|>
                             (map Constraint <$> (sepBy1 idParsers sep)))
    where
        idParsers = try (enkiId ["then"]) <|> try (baseEnkiId ["then"])
        sep = symbol $ string ","

when :: Parser Constraint
when = do
    symbol $ string "when"
    condition <- constraint

    body <- optionMaybe $ do
        symbol $ string "then"
        body <- symbol constraint
        pure body
    symbol $ char '.'

    pure $ When condition $ fromMaybe (Constraints []) body

otherwiseBranch :: Parser Constraint
otherwiseBranch = do
    lineSep
    string "otherwise"
    lineSep
    string "then"
    lineSep
    body <- constraint
    lineSep

    pure $ When body $ Constraints []

withWs :: Stream s m Char => ParsecT s st m a -> ParsecT s st m a
withWs parser = do
    a <- parser
    wsSkip
    pure a

enkiId :: Stream s m Char => [String] -> ParsecT s st m Id
enkiId = buildExpressionParser opTable . baseEnkiId

baseEnkiId :: [String] -> Parser Id
baseEnkiId excluded =
    Comp <$> untilFail (choice (map (try . withWs) [var, bool, int, str excluded, paren, quoteId]))

untilFail :: Parser a -> Parser [a]
untilFail parser = do
    r <- optionMaybe parser
    case r of
        Nothing -> pure []
        Just v -> do
            rs <- untilFail parser
            pure $ v:rs

quoteId :: Parser Id
quoteId = do
    s <- between (symbol (string "\"")) (symbol (string "\"")) $ many $ noneOf "\""
    pure $ S $ "\"" ++ s ++ "\""

paren :: Parser Id
paren = between (string "(" >> wsSkip) (wsSkip >> string ")") $ enkiId []

opTable :: Stream s m Char => OperatorTable s st m Id
opTable =
    [
        [binary "^" AssocLeft],
        [binary "*" AssocLeft, binary "/" AssocLeft, binary "mod" AssocLeft],
        [binary "+" AssocLeft, binary "-" AssocLeft],
        [binary ".." AssocLeft],
        [binary "=" AssocNone, binary ">=" AssocNone,
         binary "<=" AssocNone, binary "<" AssocNone,
         binary ">" AssocNone]
    ]

flatten (Comp [id]) = id
flatten id = id

binary :: Stream s m Char => String -> Assoc -> Operator s st m Id
binary name = Infix parse
    where
        parse = do
            op <- try $ opStr name
            pure $ \a b -> Comp [flatten a, op, flatten b]

str :: [String] -> Parser Id
str list = do
    s <- symbols -- <|> concatOp
    if s `elem` list then
        parserFail "Found item from excluded list"
    else
        pure $ S s

    where
        symbols = nonEmpty ['a'..'z'] cs
        cs = ['a'..'z'] ++ ['A'..'Z'] ++ ['0'..'9']

nonEmpty :: String -> String -> Parser String
nonEmpty start ending = do
    s <- oneOf start
    ss <- many $ oneOf ending

    pure $ s:ss

opStr :: String -> Parser Id
opStr str = S <$> symbol (string str)

exclude :: Stream s m Char => [String] -> ParsecT s st m String -> ParsecT s st m String
exclude strs parser = do
    notFollowedBy $ choice $ map (symbol . string) strs
    parser

var :: Parser Id
var = V <$> do
    s <- oneOf ['A'..'Z']
    ss <- many $ oneOf $ ['A'..'Z'] ++ ['a'..'z'] ++ ['0'..'9']

    pure $ s:ss

nonzeroDigit :: Parser Char
nonzeroDigit = oneOf "123456789"

int :: Parser Id
int = I . read <$> string "0" <|> do
    neg <- optionMaybe $ try $ string "-"
    digits <- (:) <$> nonzeroDigit <*> many digit

    pure $ I $ read $ fromMaybe "" neg ++ digits

bool :: Parser Id
bool = B . read . titleCase <$> choice [string "true", string "false"]

wsSkip :: Parser ()
wsSkip = skipMany $ oneOf " \r\t"

whitespace :: Parser ()
whitespace = skipMany1 $ oneOf " \t\n\r"

newlines :: Parser ()
newlines = skipMany1 (wsSkip >> char '\n' >> wsSkip)

symbol :: Stream s m Char => ParsecT s st m a -> ParsecT s st m a
symbol parser = do
    lineSep
    v <- parser
    lineSep
    pure v

