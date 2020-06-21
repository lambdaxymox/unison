{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}
module Unison.Editor.Data.RemoteRepo where

import Unison.Prelude
import Unison.Util.Data.Monoid as Monoid 
import Data.Text as Text
import qualified Unison.Codebase.Data.Path as Path
import Unison.Codebase.Data.Path (Path)
import Unison.Codebase.Data.ShortBranchHash (ShortBranchHash)
import qualified Unison.Codebase.Data.ShortBranchHash as SBH

data RemoteRepo = GitRepo { url :: Text, commit :: Maybe Text }
  deriving (Eq, Ord, Show)

printRepo :: RemoteRepo -> Text
printRepo GitRepo{..} = url <> Monoid.fromMaybe (Text.cons ':' <$> commit)

printNamespace :: RemoteRepo -> Maybe ShortBranchHash -> Path -> Text
printNamespace repo sbh path =
  printRepo repo <> case sbh of
    Nothing -> if path == Path.empty then mempty
      else ":." <> Path.toText path
    Just sbh -> ":#" <> SBH.toText sbh <>
      if path == Path.empty then mempty
      else "." <> Path.toText path
      
printHead :: RemoteRepo -> Path -> Text
printHead repo path = printNamespace repo Nothing path      

type RemoteNamespace = (RemoteRepo, Maybe ShortBranchHash, Path)
type RemoteHead = (RemoteRepo, Path)