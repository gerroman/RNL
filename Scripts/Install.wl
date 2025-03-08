(* ::Package:: *)

(* To Install RNL package from Wolfram Mathematica just call *)
(*Import["https://raw.githubusercontent.com/gerroman/RNL/refs/heads/fix/Scripts/Install.wl"]*)


(* github, repository, branch *)
link = "https://github.com/gerroman"
package = "RNL"
branch = "fix"

If[Not[DirectoryQ[$UserBaseDirectory]]
	|| Not[DirectoryQ[$UserDocumentsDirectory]]
	|| Not[DirectoryQ[$TemporaryDirectory]]
  , 
  (
    Print["[ERROR]: can not access to base directories ... "];
    Exit[-1]
  )
];


sourcePath = FileNameJoin[{$UserDocumentsDirectory, package<>"-"<>branch}]
If[DirectoryQ[sourcePath],
  (
    Print[StringForm["[info]: source directory `` exists", sourcePath]];
    Print["[info]: you may need to update source directory manually"];
  )
  ,
  Block[{archivelink = URLBuild[{link, package, "archive", "refs", "heads", branch <> ".zip"}],archive},
    archive = FileNameJoin[{$TemporaryDirectory, package <> "-" <> branch <> ".zip"}];
    Print[StringForm["[info]: downloading `` package archive from `` to `` ... ", package, link, archive]];
    With[{task = URLSaveAsynchronous[archivelink, archive, (Null)&]},
      WaitAsynchronousTask[task]
	];
    Print[StringForm["[info]: unpacking archive `` to `` ... ", archive, DirectoryName[sourcePath]]];
    ExtractArchive[archive, DirectoryName[sourcePath]];
  ]
 ];


packagePath = FileNameJoin[{$UserBaseDirectory, "Applications", package}];
Print[StringForm["[info]: setting up loading files from `` ... ", FileNameJoin[{sourcePath, "Packages"}], packagePath]];

SetDirectory[FileNameJoin[{sourcePath, "Packages"}]];
files = Join[FileNames["*.wl"], FileNames["*.m"]];
files = DeleteDuplicatesBy[files, FileBaseName];
files = DeleteCases[files, ToString[StringForm["make``.m",package]]];

Scan[
  Function[file, 
    Block[{fname = FileNameJoin[{packagePath, FileBaseName[file]<>".m"}], writeflag},
      writeflag = If[FileExistsQ[fname],
        InputString["You already have " <> fname <> ". Overwrite? (y/n)"] === "y"
	    ,
	    True
      ];
      If[writeflag, 
	    With[{init = OpenWrite[fname]}, (
          WriteString[init, StringForm["Get[FileNameJoin[{$UserDocumentsDirectory, \"``\", \"``\", \"``\"}]]", package <> "-" <> branch, "Packages", file]];
          Close[init]
	    )];
        Print[StringForm["Installed shortcut for ``. Use\n  << ```.````.`", file, package, FileBaseName[file]]]
      ]
    ]
  ]
  ,
  files
]