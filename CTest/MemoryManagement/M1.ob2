MODULE M1;
IMPORT O:=Out, Storage, SysLib;

PROCEDURE PrintInfo*;
VAR inf:Storage.tHeapInfo;
BEGIN (* PrintInfo *)
 Storage.GetInfo(inf); 
 O.StrLn("Heap Info:"); 
 O.Str("TotalFreeBytes = "); O.Int(inf.TotalFreeBytes); O.Str(" = "); O.Int(inf.TotalFreeBytes DIV 1024); O.Str(" KB"); O.Ln;
 O.Str("MaxFreeBytes   = "); O.Int(inf.MaxFreeBytes  ); O.Str(" = "); O.Int(inf.MaxFreeBytes DIV 1024); O.Str(" KB"); O.Ln;
 O.Str("TotalBytes     = "); O.Int(inf.TotalBytes    ); O.Ln;
 O.Str("End            = "); O.Hex(inf.End           ); O.Str(' '); O.Int(inf.End); O.Ln;
 O.Str("Start          = "); O.Hex(inf.Start         ); O.Str(' '); O.Int(inf.Start); O.Ln;
 O.Str("NofFreeBlocks  = "); O.Int(inf.NofFreeBlocks ); O.Ln;
 
 O.Str("sbrk           = "); O.Int(SysLib.sbrk(0)); O.Ln;
END PrintInfo;

END M1.
