module Nixfmt.Types where

import           Data.Text       hiding (concat, map)
import           Data.Void
import           Text.Megaparsec (Parsec)

type Parser = Parsec Void Text

data Trivium = EmptyLine
             | LineComment     Text
             | BlockComment    [Text]
             deriving (Eq, Show)

type Trivia = [Trivium]

data AST n l = Node n [AST n l]
             -- | A token followed by an optional trailing comment
             | Leaf l (Maybe Text)
             | Trivia Trivia
             deriving (Eq)

type NixAST = AST NodeType NixToken

data Fixity = Prefix
            | InfixL
            | InfixN
            | InfixR
            | Postfix

data Operator = Op Fixity NixToken
              | Apply

operators :: [[Operator]]
operators = [ [ Apply ]
            , [ Op Prefix TMinus ]
            , [ Op Postfix TQuestion ]
            , [ Op InfixR TConcat ]
            , [ Op InfixL TMul
              , Op InfixL TDiv ]
            , [ Op InfixL TPlus
              , Op InfixL TMinus ]
            , [ Op Prefix TUpdate ]
            , [ Op InfixN TLess
              , Op InfixN TGreater
              , Op InfixN TLessEqual
              , Op InfixN TGreaterEqual ]
            , [ Op InfixN TEqual
              , Op InfixN TUnequal ]
            , [ Op InfixL TBoolAnd ]
            , [ Op InfixL TBoolOr ]
            , [ Op InfixL TImplies ]
            ]

data NodeType
    = Abstraction
    | Application
    | Assert
    | Assignment
    | ContextParameter
    | AttrParameter
    | File
    | IfElse
    | Inherit
    | Let
    | List
    | Parenthesized
    | Set
    | SetParameter
    | With
    deriving (Eq, Show)

data NixToken
    = EnvPath    Text
    | Identifier Text
    | NixFloat   Text
    | NixInt     Int
    | NixText    Text
    | NixURI     Text

    | TAssert
    | TElse
    | TIf
    | TIn
    | TInherit
    | TLet
    | TOr
    | TRec
    | TThen
    | TWith

    | TBraceOpen
    | TBraceClose
    | TBrackOpen
    | TBrackClose
    | TParenOpen
    | TParenClose

    | TAssign
    | TAt
    | TColon
    | TComma
    | TDot
    | TEllipsis
    | TQuestion
    | TSemicolon

    | TConcat
    | TNegate
    | TUpdate

    | TPlus
    | TMinus
    | TMul
    | TDiv

    | TBoolAnd
    | TEqual
    | TImplies
    | TLess
    | TLessEqual
    | TGreater
    | TGreaterEqual
    | TUnequal
    | TBoolOr

    | TEOF
    deriving (Eq)

instance (Show n, Show l) => Show (AST n l) where
    show (Leaf l Nothing)  = show l
    show (Leaf l (Just c)) = show l <> show "/*" <> show c <> show "*/"
    show (Trivia ts)       = show ts
    show (Node n xs)       = concat
        [ show n
        , "("
        , concat $ map show xs
        , ")"
        ]

instance Show NixToken where
    show (Identifier i) = show i
    show (EnvPath p)    = show p
    show (NixFloat f)   = show f
    show (NixInt i)     = show i
    show (NixURI u)     = show u
    show (NixText t)    = show t

    show TAssert        = "assert"
    show TElse          = "else"
    show TIf            = "if"
    show TIn            = "in"
    show TInherit       = "inherit"
    show TLet           = "let"
    show TOr            = "or"
    show TRec           = "rec"
    show TThen          = "then"
    show TWith          = "with"

    show TBraceOpen     = "{"
    show TBraceClose    = "}"
    show TBrackOpen     = "["
    show TBrackClose    = "]"
    show TParenOpen     = "("
    show TParenClose    = ")"

    show TAssign        = "="
    show TAt            = "@"
    show TColon         = ":"
    show TComma         = ","
    show TDot           = "."
    show TEllipsis      = "..."
    show TQuestion      = "?"
    show TSemicolon     = ";"

    show TPlus          = "+"
    show TMinus         = "-"
    show TMul           = "*"
    show TDiv           = "/"
    show TConcat        = "++"
    show TUpdate        = "//"

    show TBoolAnd       = "&&"
    show TBoolOr        = "||"
    show TImplies       = "->"
    show TEqual         = "=="
    show TUnequal       = "!="
    show TLess          = "<"
    show TGreater       = ">"
    show TLessEqual     = "<="
    show TGreaterEqual  = ">="

    show TEOF           = ""
