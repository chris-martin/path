{-# LANGUAGE FlexibleInstances #-}
module Path.Gen where

import           Path
import           Path.Internal

import qualified System.FilePath as FilePath

import           Data.List (isInfixOf)
import           Data.Validity
import           Data.GenValidity

import           Test.QuickCheck


instance Validity (Path Abs File) where
  isValid p@(Path fp)
    =  FilePath.isAbsolute fp
    && not (FilePath.hasTrailingPathSeparator fp)
    && FilePath.isValid fp
    && not (".." `isInfixOf` fp)
    && not (containsLineBreaks fp)
    && (parseAbsFile fp == Just p)

instance Validity (Path Rel File) where
  isValid p@(Path fp)
    =  FilePath.isRelative fp
    && not (FilePath.hasTrailingPathSeparator fp)
    && FilePath.isValid fp
    && fp /= "."
    && fp /= ".."
    && not (".." `isInfixOf` fp)
    && not (containsLineBreaks fp)
    && (parseRelFile fp == Just p)

instance Validity (Path Abs Dir) where
  isValid p@(Path fp)
    =  FilePath.isAbsolute fp
    && FilePath.hasTrailingPathSeparator fp
    && FilePath.isValid fp
    && not (".." `isInfixOf` fp)
    && not (containsLineBreaks fp)
    && (parseAbsDir fp == Just p)

instance Validity (Path Rel Dir) where
  isValid p@(Path fp)
    =  FilePath.isRelative fp
    && FilePath.hasTrailingPathSeparator fp
    && FilePath.isValid fp
    && not (null fp)
    && fp /= "."
    && fp /= ".."
    && not (".." `isInfixOf` fp)
    && not (containsLineBreaks fp)
    && (parseRelDir fp == Just p)


containsLineBreaks :: String -> Bool
containsLineBreaks s = any (`elem` s) "\n\r"

instance GenUnchecked (Path Abs File) where
  genUnchecked = Path <$> arbitrary

instance GenValid (Path Abs File)

instance GenUnchecked (Path Rel File) where
  genUnchecked = Path <$> arbitrary

instance GenValid (Path Rel File)

instance GenUnchecked (Path Abs Dir) where
  genUnchecked = Path <$> arbitrary

instance GenValid (Path Abs Dir)

instance GenUnchecked (Path Rel Dir) where
  genUnchecked = Path <$> arbitrary

instance GenValid (Path Rel Dir)

