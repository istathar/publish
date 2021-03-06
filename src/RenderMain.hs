{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import Core.Program
import Core.Text
import RenderDocument (program, initial)
import Paths_publish (version)


main :: IO ()
main = do
    context <- configure (fromPackage version) initial (simple
        [ Option "default-preamble" (Just 'p') Empty [quote|
            Wrap a built-in default LaTeX preamble (and ending) around your
            supplied source fragments. Most documents will put their own
            custom preamble as the first fragment in the .book file, but
            for getting started a suitable default can be employed via this
            option.
          |]
        , Option "docker" Nothing (Value "IMAGE") [quote|
            Run the specified Docker image in a container, mount the target
            directory into it as a volume, and do the build there. This allows
            you to have all of the LaTeX dependencies separate from the machine
            you are editing on.
          |]
        , Argument "bookfile" [quote|
            The file containing the list of fragments making up this book.
            If the argument is specified as "Hobbit.book" then "Hobbit"
            will be used as the basename for the intermediate .latex file
            and the final output .pdf file. The list file should contain
            filenames, one per line, of the fragments you wish to render
            into a complete document.
          |]
        ])

    executeWith context program
