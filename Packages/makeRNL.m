(* ::Package:: *)

(*
makeShortcut.m - written by Roman Lee.
*)
PACKAGE="RNL";

thisfile=If[$Notebooks,NotebookFileName[],$InputFileName];
SetDirectory[DirectoryName[thisfile]];
appdir=FileNameJoin[{$UserBaseDirectory, "Applications", PACKAGE}];
files = Join[FileNames["*.wl"],FileNames["*.m"]];
If[files==={},Print["No "<>"*.m, *.wl files in "<>Directory[]<>". Changed nothing, quitting..."];Quit[]];
files=DeleteCases[DeleteDuplicatesBy[files,FileBaseName],FileNameTake[thisfile]];
Quiet[CreateDirectory[appdir]];
Scan[Function[file,
fn=FileNameJoin[{appdir, FileBaseName[file]<>".m"}];
If[FileExistsQ[fn],write=Replace[InputString["You already have "<>fn<>". Overwrite? (y/n)"],{"y"|"yes"->True,_->False}],write=True];
If[write,
init=OpenWrite[fn];
WriteString[init, ToString@StringForm["Get[``]", ToString[FileNameJoin[{Directory[], file}], InputForm]]];
Close[init];
Print["Installed shortcut for "<>file<>". Use\n  <<"<>PACKAGE<>"`"<>FileBaseName[file]<>"`"]]],
files]
Quit[]
