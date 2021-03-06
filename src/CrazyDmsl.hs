{-# LANGUAGE ApplicativeDo #-}

module CrazyDmsl where

import Control.Applicative

import Parsers

type Loc = (Int, Int)
type IntR = (Int, Int)
type Dir = (Int, Loc)
type DirR = (IntR, Loc)

type Vect = (Int, Dir)
type VectR = (IntR, DirR)

data CondVar' = CurrentFrame | LocX | LocY deriving (Show, Eq)
data Rela' = Bigger | Same | Smaller deriving (Show, Eq)
data CondVar = CondVar CondVar' Rela' Int  deriving (Show, Eq)
data Logic = And | Or deriving (Show, Eq)

data Event = Event
  { condition1 :: CondVar
  , condition2 :: Maybe (Logic, CondVar)
  } deriving (Eq, Show)

data Shooter = Shooter
  { shooterId :: Int
  , layerId :: Int
  , bindState :: Bool
  , bindId :: Int
  , relativeDir :: Bool
  , locationX :: IntR
  , locationY :: IntR
  , initiate :: Int
  , continuous :: Int
  , shootLoc :: Loc
  , radius :: VectR
  , ways :: IntR
  , cycleC :: IntR
  , shootAngle :: DirR
  , range :: IntR
  , speed :: VectR
  , acceleration :: VectR
  , life :: Int
  , bulletType :: Int
  , widthProp :: Int
  , heightProp :: Int
  , red :: Int
  , blue :: Int
  , green :: Int
  , opacity :: Int
  , orientation :: DirR
  , faceSpeedDir :: Bool
  , bulletSpeed :: VectR
  , bulletAcceleration :: VectR
  , horizontalProp :: Int
  , verticalProp :: Int
  , foggify :: Bool
  , removify :: Bool
  , highlightify :: Bool
  , shadowify :: Bool
  , autoGCify :: Bool
  , indefensiblify :: Bool
  , shooterEvents :: [Event]
  , bulletEvents :: [Event]
  , influencedByCup :: Bool
  , influencedByRefl :: Bool
  , influencedByField :: Bool
  , deepBind :: Bool
  } deriving (Show)
--

intP :: Parser Int
intP = do
  a <- option0 ' ' $ charP '-'
  b <- some digitP
  return $ case a of
    '-' -> -1 * read b
    _   -> read b
--

boolP :: Parser Bool
boolP = do
  a <- stringsP [ "True", "False" ]
  return $ read a
--

s = (charP ',' >>)
intSP = s intP
boolSP = s boolP

locP :: Parser Loc
locP = do
  stringP "{X:"
  x <- intP
  stringP " Y:"
  y <- intP
  stringP "}"
  return (x, y)
--  

shooterP :: Parser Shooter
shooterP = let sep = charP ',' in do
  shooterId' <- intP
  layerId' <- intSP
  bindState' <- boolSP
  bindId' <- intSP
  relativeDir' <- boolSP
  sep
  locationX' <- intSP
  locationY' <- intSP
  initiate' <- intSP
  continuous' <- intSP
  shootX <- intSP
  shootY <- intSP
  radius' <- intSP
  radiusDir <- intSP
  radiusDir' <- s locP
  ways' <- intSP
  cycleC' <- intSP
  shootAngleDir <- intSP
  shootAngleDir' <- s locP
  range' <- intSP
  speed' <- intSP
  speedDir <- intSP
  speedDir' <- s locP
  acce' <- intSP
  acceDir <- intSP
  acceDir' <- s locP
  life' <- intSP
  bulletType' <- intSP
  widthProp' <- intSP
  heightProp' <- intSP
  red' <- intSP
  blue' <- intSP
  green' <- intSP
  opacity' <- intSP
  orientation' <- intSP
  orientationDir <- s locP
  faceSpeedDir' <- boolSP
  bSpeed' <- intSP
  bSpeedDir <- intSP
  bSpeedDir' <- s locP
  bAcce' <- intSP
  bAcceDir <- intSP
  bAcceDir' <- s locP
  horizontalProp' <- intSP
  verticalProp' <- intSP
  foggify' <- boolSP
  removify' <- boolSP
  highlightify' <- boolSP
  shadowify' <- boolSP
  autoGCify' <- boolSP
  indefensiblify' <- boolSP
  shooterEvents' <- s $ eventP /|\ charP '&'
  bulletEvents' <- s $ eventP /|\ charP '&'
  locationX'' <- intSP
  locationY'' <- intSP
  radius'' <- intSP
  radiusDir'' <- intSP
  ways'' <- intSP
  cycleC'' <- intSP
  shootAngleDir'' <- intSP
  range'' <- intSP
  speed'' <- intSP
  speedDir'' <- intSP
  acce'' <- intSP
  acceDir'' <- intSP
  orientationDir' <- intSP
  bSpeed'' <- intSP
  bSpeedDir'' <- intSP
  bAcce'' <- intSP
  bAcceDir'' <- intSP
  influencedByCup' <- boolSP
  influencedByRefl' <- boolSP
  influencedByField' <- boolSP
  deepBind' <- boolSP

  return Shooter
    { shooterId = shooterId'
    , layerId = layerId'
    , bindState = bindState'
    , bindId = bindId'
    , relativeDir = relativeDir'
    , locationX = (locationX', locationX'')
    , locationY = (locationY', locationY'')
    , initiate = initiate'
    , continuous = continuous'
    , shootLoc = (shootX, shootY)
    , radius = ((radius', radius''), ((radiusDir, radiusDir''), radiusDir'))
    , ways = (ways', ways'')
    , cycleC = (cycleC', cycleC'')
    , shootAngle = ((shootAngleDir, shootAngleDir''), shootAngleDir')
    , range = (range', range'')
    , speed = ((speed', speed''), ((speedDir, speedDir''), speedDir'))
    , acceleration = ((acce', acce''), ((acceDir, acceDir''), acceDir'))
    , life = life'
    , bulletType = bulletType'
    , widthProp = widthProp'
    , heightProp = heightProp'
    , red = red'
    , blue = blue'
    , green = green'
    , opacity = opacity'
    , orientation = ((orientation', orientationDir'), orientationDir)
    , faceSpeedDir = faceSpeedDir'
    , bulletSpeed = ((bSpeed', bSpeed''), ((bSpeedDir, bSpeedDir''), bSpeedDir'))
    , bulletAcceleration = ((bAcce', bAcce''), ((bAcceDir, bAcceDir''), bAcceDir'))
    , horizontalProp = horizontalProp'
    , verticalProp = verticalProp'
    , foggify = foggify'
    , removify = removify'
    , highlightify = highlightify'
    , shadowify = shadowify'
    , autoGCify = autoGCify'
    , indefensiblify = indefensiblify'
    , shooterEvents = shooterEvents'
    , bulletEvents = bulletEvents'
    , influencedByCup = influencedByCup'
    , influencedByRefl = influencedByRefl'
    , influencedByField = influencedByField'
    , deepBind = deepBind'
    }
--

condP :: Parser CondVar
condP = do
  var' <- "当前帧" ->> CurrentFrame
         <|> "X座标" ->> LocX
         <|> "Y座标" ->> LocY
  rela' <- ">" ->> Bigger
         <|> "=" ->> Same
         <|> "<" ->> Smaller
  int' <- intP
  return $ CondVar var' rela' int'
--

eventP :: Parser Event
eventP = do
  cond1 <- condP
  cond2 <- option0 Nothing $ do
    a <- "且" ->> And <|> "或" ->> Or
    c <- condP
    return $ Just (a, c)
  stringP "："
  return Event
    { condition1 = cond1
    , condition2 = cond2
    }

crazyDmslP :: Parser String
crazyDmslP = stringP "a"

