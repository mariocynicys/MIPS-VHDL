#!/usr/bin/env python3
import os.path
import os

def main():
  project_dir = os.path.dirname(__file__)

  vhdls = [os.path.abspath(vhdl)
          for vhdl in os.listdir(project_dir)
          if vhdl.endswith(('.vhd', '.vhdl'))]

  vhdls.sort()
  vhdl_count = FILE_COUNT.format(len(vhdls))
  vhdl_files = '\n'.join([NEW_FILE.format(i, vhdl)
                        for (i, vhdl) in enumerate(vhdls)])

  mips_mpf = TMPL.format(vhdl_count, vhdl_files)
  with open('mips.mpf', 'w') as file:
    file.write(mips_mpf)

FILE_COUNT = '''Project_Files_Count = {0}'''

NEW_FILE='''Project_File_{0} = {1}\nProject_File_P_{0} = vhdl_novitalcheck 0 file_type vhdl group_id 0 cover_nofec 0 vhdl_nodebug 0 vhdl_1164 1 vhdl_noload 0 vhdl_synth 0 vhdl_enable0In 0 folder {{Top Level}} last_compile 0 vhdl_disableopt 0 vhdl_vital 0 cover_excludedefault 0 vhdl_warn1 1 vhdl_warn2 1 vhdl_explicit 1 vhdl_showsource 0 vhdl_warn3 1 cover_covercells 0 vhdl_0InOptions {{}} vhdl_warn4 1 voptflow 1 cover_optlevel 3 vhdl_options {{}} vhdl_warn5 1 toggle - ood 1 cover_noshort 0 compile_to work compile_order {0} cover_nosub 0 dont_compile 0 vhdl_use93 2008'''

TMPL = '''; Copyright 1991-2009 Mentor Graphics Corporation
;
; All Rights Reserved.
;
; THIS WORK CONTAINS TRADE SECRET AND PROPRIETARY INFORMATION WHICH IS THE PROPERTY OF 
; MENTOR GRAPHICS CORPORATION OR ITS LICENSORS AND IS SUBJECT TO LICENSE TERMS.
;   

[Library]
std = $MODEL_TECH/../std
ieee = $MODEL_TECH/../ieee
verilog = $MODEL_TECH/../verilog
vital2000 = $MODEL_TECH/../vital2000
std_developerskit = $MODEL_TECH/../std_developerskit
synopsys = $MODEL_TECH/../synopsys
modelsim_lib = $MODEL_TECH/../modelsim_lib
sv_std = $MODEL_TECH/../sv_std

; Altera Primitive libraries
;
; VHDL Section
;
altera_mf = $MODEL_TECH/../altera/vhdl/altera_mf
altera = $MODEL_TECH/../altera/vhdl/altera
altera_lnsim = $MODEL_TECH/../altera/vhdl/altera_lnsim
lpm = $MODEL_TECH/../altera/vhdl/220model
220model = $MODEL_TECH/../altera/vhdl/220model
maxii = $MODEL_TECH/../altera/vhdl/maxii
maxv = $MODEL_TECH/../altera/vhdl/maxv
fiftyfivenm = $MODEL_TECH/../altera/vhdl/fiftyfivenm
sgate = $MODEL_TECH/../altera/vhdl/sgate
arriaii = $MODEL_TECH/../altera/vhdl/arriaii
arriaii_hssi = $MODEL_TECH/../altera/vhdl/arriaii_hssi
arriaii_pcie_hip = $MODEL_TECH/../altera/vhdl/arriaii_pcie_hip
arriaiigz = $MODEL_TECH/../altera/vhdl/arriaiigz
arriaiigz_hssi = $MODEL_TECH/../altera/vhdl/arriaiigz_hssi
arriaiigz_pcie_hip = $MODEL_TECH/../altera/vhdl/arriaiigz_pcie_hip
stratixiv = $MODEL_TECH/../altera/vhdl/stratixiv
stratixiv_hssi = $MODEL_TECH/../altera/vhdl/stratixiv_hssi
stratixiv_pcie_hip = $MODEL_TECH/../altera/vhdl/stratixiv_pcie_hip
cycloneiv = $MODEL_TECH/../altera/vhdl/cycloneiv
cycloneiv_hssi = $MODEL_TECH/../altera/vhdl/cycloneiv_hssi
cycloneiv_pcie_hip = $MODEL_TECH/../altera/vhdl/cycloneiv_pcie_hip
cycloneive = $MODEL_TECH/../altera/vhdl/cycloneive
stratixv = $MODEL_TECH/../altera/vhdl/stratixv
stratixv_hssi = $MODEL_TECH/../altera/vhdl/stratixv_hssi
stratixv_pcie_hip = $MODEL_TECH/../altera/vhdl/stratixv_pcie_hip
arriavgz = $MODEL_TECH/../altera/vhdl/arriavgz
arriavgz_hssi = $MODEL_TECH/../altera/vhdl/arriavgz_hssi
arriavgz_pcie_hip = $MODEL_TECH/../altera/vhdl/arriavgz_pcie_hip
arriav = $MODEL_TECH/../altera/vhdl/arriav
cyclonev = $MODEL_TECH/../altera/vhdl/cyclonev
twentynm = $MODEL_TECH/../altera/vhdl/twentynm
twentynm_hssi = $MODEL_TECH/../altera/vhdl/twentynm_hssi
twentynm_hip = $MODEL_TECH/../altera/vhdl/twentynm_hip
cyclone10lp = $MODEL_TECH/../altera/vhdl/cyclone10lp
;
; Verilog Section
;
altera_mf_ver = $MODEL_TECH/../altera/verilog/altera_mf
altera_ver = $MODEL_TECH/../altera/verilog/altera
altera_lnsim_ver = $MODEL_TECH/../altera/verilog/altera_lnsim
lpm_ver = $MODEL_TECH/../altera/verilog/220model
220model_ver = $MODEL_TECH/../altera/verilog/220model
maxii_ver = $MODEL_TECH/../altera/verilog/maxii
maxv_ver = $MODEL_TECH/../altera/verilog/maxv
fiftyfivenm_ver = $MODEL_TECH/../altera/verilog/fiftyfivenm
sgate_ver = $MODEL_TECH/../altera/verilog/sgate
arriaii_ver = $MODEL_TECH/../altera/verilog/arriaii
arriaii_hssi_ver = $MODEL_TECH/../altera/verilog/arriaii_hssi
arriaii_pcie_hip_ver = $MODEL_TECH/../altera/verilog/arriaii_pcie_hip
arriaiigz_ver = $MODEL_TECH/../altera/verilog/arriaiigz
arriaiigz_hssi_ver = $MODEL_TECH/../altera/verilog/arriaiigz_hssi
arriaiigz_pcie_hip_ver = $MODEL_TECH/../altera/verilog/arriaiigz_pcie_hip
stratixiv_ver = $MODEL_TECH/../altera/verilog/stratixiv
stratixiv_hssi_ver = $MODEL_TECH/../altera/verilog/stratixiv_hssi
stratixiv_pcie_hip_ver = $MODEL_TECH/../altera/verilog/stratixiv_pcie_hip
stratixv_ver = $MODEL_TECH/../altera/verilog/stratixv
stratixv_hssi_ver = $MODEL_TECH/../altera/verilog/stratixv_hssi
stratixv_pcie_hip_ver = $MODEL_TECH/../altera/verilog/stratixv_pcie_hip
arriavgz_ver = $MODEL_TECH/../altera/verilog/arriavgz
arriavgz_hssi_ver = $MODEL_TECH/../altera/verilog/arriavgz_hssi
arriavgz_pcie_hip_ver = $MODEL_TECH/../altera/verilog/arriavgz_pcie_hip
arriav_ver = $MODEL_TECH/../altera/verilog/arriav
arriav_hssi_ver = $MODEL_TECH/../altera/verilog/arriav_hssi
arriav_pcie_hip_ver = $MODEL_TECH/../altera/verilog/arriav_pcie_hip
cyclonev_ver = $MODEL_TECH/../altera/verilog/cyclonev
cyclonev_hssi_ver = $MODEL_TECH/../altera/verilog/cyclonev_hssi
cyclonev_pcie_hip_ver = $MODEL_TECH/../altera/verilog/cyclonev_pcie_hip
cycloneiv_ver = $MODEL_TECH/../altera/verilog/cycloneiv
cycloneiv_hssi_ver = $MODEL_TECH/../altera/verilog/cycloneiv_hssi
cycloneiv_pcie_hip_ver = $MODEL_TECH/../altera/verilog/cycloneiv_pcie_hip
cycloneive_ver = $MODEL_TECH/../altera/verilog/cycloneive
twentynm_ver = $MODEL_TECH/../altera/verilog/twentynm
twentynm_hssi_ver = $MODEL_TECH/../altera/verilog/twentynm_hssi
twentynm_hip_ver = $MODEL_TECH/../altera/verilog/twentynm_hip
cyclone10lp_ver = $MODEL_TECH/../altera/verilog/cyclone10lp

work = work
[vcom]
; VHDL93 variable selects language version as the default. 
; Default is VHDL-2002.
; Value of 0 or 1987 for VHDL-1987.
; Value of 1 or 1993 for VHDL-1993.
; Default or value of 2 or 2002 for VHDL-2002.
; Default or value of 3 or 2008 for VHDL-2008.
VHDL93 = 2008

; Show source line containing error. Default is off.
; Show_source = 1

; Turn off unbound-component warnings. Default is on.
; Show_Warning1 = 0

; Turn off process-without-a-wait-statement warnings. Default is on.
; Show_Warning2 = 0

; Turn off null-range warnings. Default is on.
; Show_Warning3 = 0

; Turn off no-space-in-time-literal warnings. Default is on.
; Show_Warning4 = 0

; Turn off multiple-drivers-on-unresolved-signal warnings. Default is on.
; Show_Warning5 = 0

; Turn off optimization for IEEE std_logic_1164 package. Default is on.
; Optimize_1164 = 0

; Turn on resolving of ambiguous function overloading in favor of the
; "explicit" function declaration (not the one automatically created by
; the compiler for each type declaration). Default is off.
; The .ini file has Explicit enabled so that std_logic_signed/unsigned
; will match the behavior of synthesis tools.
Explicit = 1

; Turn off acceleration of the VITAL packages. Default is to accelerate.
; NoVital = 1

; Turn off VITAL compliance checking. Default is checking on.
; NoVitalCheck = 1

; Ignore VITAL compliance checking errors. Default is to not ignore.
; IgnoreVitalErrors = 1

; Turn off VITAL compliance checking warnings. Default is to show warnings.
; Show_VitalChecksWarnings = 0

; Keep silent about case statement static warnings.
; Default is to give a warning.
; NoCaseStaticError = 1

; Keep silent about warnings caused by aggregates that are not locally static.
; Default is to give a warning.
; NoOthersStaticError = 1

; Turn off inclusion of debugging info within design units.
; Default is to include debugging info.
; NoDebug = 1

; Turn off "Loading..." messages. Default is messages on.
; Quiet = 1

; Turn on some limited synthesis rule compliance checking. Checks only:
;    -- signals used (read) by a process must be in the sensitivity list
; CheckSynthesis = 1

; Activate optimizations on expressions that do not involve signals,
; waits, or function/procedure/task invocations. Default is off.
; ScalarOpts = 1

; Require the user to specify a configuration for all bindings,
; and do not generate a compile time default binding for the
; component. This will result in an elaboration error of
; 'component not bound' if the user fails to do so. Avoids the rare
; issue of a false dependency upon the unused default binding.
; RequireConfigForAllDefaultBinding = 1

; Inhibit range checking on subscripts of arrays. Range checking on
; scalars defined with subtypes is inhibited by default.
; NoIndexCheck = 1

; Inhibit range checks on all (implicit and explicit) assignments to
; scalar objects defined with subtypes.
; NoRangeCheck = 1

[vlog]

; Turn off inclusion of debugging info within design units.
; Default is to include debugging info.
; NoDebug = 1

; Turn off "loading..." messages. Default is messages on.
; Quiet = 1

; Turn on Verilog hazard checking (order-dependent accessing of global vars).
; Default is off.
; Hazard = 1

; Turn on converting regular Verilog identifiers to uppercase. Allows case
; insensitivity for module names. Default is no conversion.
; UpCase = 1

; Turn on incremental compilation of modules. Default is off.
; Incremental = 1

; Turns on lint-style checking.
; Show_Lint = 1

[vsim]
; Simulator resolution
; Set to fs, ps, ns, us, ms, or sec with optional prefix of 1, 10, or 100.
Resolution = ps

; User time unit for run commands
; Set to default, fs, ps, ns, us, ms, or sec. The default is to use the
; unit specified for Resolution. For example, if Resolution is 100ps,
; then UserTimeUnit defaults to ps.
; Should generally be set to default.
UserTimeUnit = default

; Default run length
RunLength = 100

; Maximum iterations that can be run without advancing simulation time
IterationLimit = 5000

; Directive to license manager:
; vhdl          Immediately reserve a VHDL license
; vlog          Immediately reserve a Verilog license
; plus          Immediately reserve a VHDL and Verilog license
; nomgc         Do not look for Mentor Graphics Licenses
; nomti         Do not look for Model Technology Licenses
; noqueue       Do not wait in the license queue when a license isn't available
; viewsim	Try for viewer license but accept simulator license(s) instead
;		of queuing for viewer license
; License = plus

; Stop the simulator after a VHDL/Verilog assertion message
; 0 = Note  1 = Warning  2 = Error  3 = Failure  4 = Fatal
BreakOnAssertion = 3

; Assertion Message Format
; %S - Severity Level 
; %R - Report Message
; %T - Time of assertion
; %D - Delta
; %I - Instance or Region pathname (if available)
; %% - print '%' character
; AssertionFormat = "** %S: %R\n   Time: %T  Iteration: %D%I\n"

; Assertion File - alternate file for storing VHDL/Verilog assertion messages
; AssertFile = assert.log

; Default radix for all windows and commands...
; Set to symbolic, ascii, binary, octal, decimal, hex, unsigned
DefaultRadix = symbolic

; VSIM Startup command
; Startup = do startup.do

; File for saving command transcript
TranscriptFile = transcript

; File for saving command history
; CommandHistory = cmdhist.log

; Specify whether paths in simulator commands should be described
; in VHDL or Verilog format.
; For VHDL, PathSeparator = /
; For Verilog, PathSeparator = .
; Must not be the same character as DatasetSeparator.
PathSeparator = /

; Specify the dataset separator for fully rooted contexts.
; The default is ':'. For example, sim:/top
; Must not be the same character as PathSeparator.
DatasetSeparator = :

; Disable VHDL assertion messages
; IgnoreNote = 1
; IgnoreWarning = 1
; IgnoreError = 1
; IgnoreFailure = 1

; Default force kind. May be freeze, drive, deposit, or default
; or in other terms, fixed, wired, or charged.
; A value of "default" will use the signal kind to determine the
; force kind, drive for resolved signals, freeze for unresolved signals
; DefaultForceKind = freeze

; If zero, open files when elaborated; otherwise, open files on
; first read or write.  Default is 0.
; DelayFileOpen = 1

; Control VHDL files opened for write.
;   0 = Buffered, 1 = Unbuffered
UnbufferedOutput = 0

; Control the number of VHDL files open concurrently.
; This number should always be less than the current ulimit
; setting for max file descriptors.
;   0 = unlimited
ConcurrentFileLimit = 40

; Control the number of hierarchical regions displayed as
; part of a signal name shown in the Wave window.
; A value of zero tells VSIM to display the full name.
; The default is 0.
; WaveSignalNameWidth = 0

; Turn off warnings from the std_logic_arith, std_logic_unsigned
; and std_logic_signed packages.
; StdArithNoWarnings = 1

; Turn off warnings from the IEEE numeric_std and numeric_bit packages.
; NumericStdNoWarnings = 1

; Control the format of the (VHDL) FOR generate statement label
; for each iteration.  Do not quote it.
; The format string here must contain the conversion codes %s and %d,
; in that order, and no other conversion codes.  The %s represents
; the generate_label; the %d represents the generate parameter value
; at a particular generate iteration (this is the position number if
; the generate parameter is of an enumeration type).  Embedded whitespace
; is allowed (but discouraged); leading and trailing whitespace is ignored.
; Application of the format must result in a unique scope name over all
; such names in the design so that name lookup can function properly.
; GenerateFormat = %s__%d

; Specify whether checkpoint files should be compressed.
; The default is 1 (compressed).
; CheckpointCompressMode = 0

; List of dynamically loaded objects for Verilog PLI applications
; Veriuser = veriuser.sl

; Specify default options for the restart command. Options can be one
; or more of: -force -nobreakpoint -nolist -nolog -nowave
; DefaultRestartOptions = -force

; HP-UX 10.20 ONLY - Enable memory locking to speed up large designs
; (> 500 megabyte memory footprint). Default is disabled.
; Specify number of megabytes to lock.
; LockedMemory = 1000

; Turn on (1) or off (0) WLF file compression.
; The default is 1 (compress WLF file).
; WLFCompress = 0

; Specify whether to save all design hierarchy (1) in the WLF file
; or only regions containing logged signals (0).
; The default is 0 (save only regions with logged signals).
; WLFSaveAllRegions = 1

; WLF file time limit.  Limit WLF file by time, as closely as possible,
; to the specified amount of simulation time.  When the limit is exceeded
; the earliest times get truncated from the file.
; If both time and size limits are specified the most restrictive is used.
; UserTimeUnits are used if time units are not specified.
; The default is 0 (no limit).  Example: WLFTimeLimit = {{100 ms}}
; WLFTimeLimit = 0

; WLF file size limit.  Limit WLF file size, as closely as possible,
; to the specified number of megabytes.  If both time and size limits
; are specified then the most restrictive is used.
; The default is 0 (no limit).
; WLFSizeLimit = 1000

; Specify whether or not a WLF file should be deleted when the
; simulation ends.  A value of 1 will cause the WLF file to be deleted.
; The default is 0 (do not delete WLF file when simulation ends).
; WLFDeleteOnQuit = 1

; Automatic SDF compilation
; Disables automatic compilation of SDF files in flows that support it.
; Default is on, uncomment to turn off.
; NoAutoSDFCompile = 1

[lmc]

[msg_system]
; Change a message severity or suppress a message.
; The format is: <msg directive> = <msg number>[,<msg number>...]
; Examples:
;   note = 3009
;   warning = 3033
;   error = 3010,3016
;   fatal = 3016,3033
;   suppress = 3009,3016,3043
; The command verror <msg number> can be used to get the complete
; description of a message.

; Control transcripting of elaboration/runtime messages.
; The default is to have messages appear in the transcript and 
; recorded in the wlf file (messages that are recorded in the
; wlf file can be viewed in the MsgViewer).  The other settings
; are to send messages only to the transcript or only to the 
; wlf file.  The valid values are
;    both  {{default}}
;    tran  {{transcript only}}
;    wlf   {{wlf file only}}
; msgmode = both
[Project]
** Warning: ; Warning -- Do not edit the project properties directly.
;            Property names are dynamic in nature and property
;            values have special syntax.  Changing property data directly
;            can result in a corrupt MPF file.  All project properties
;            can be modified through project window dialogs.
Project_Version = 6
Project_DefaultLib = work
Project_SortMethod = unused
{0}
{1}
Project_Sim_Count = 0
Project_Folder_Count = 0
Echo_Compile_Output = 0
Save_Compile_Report = 1
Project_Opt_Count = 0
ForceSoftPaths = 0
ProjectStatusDelay = 5000
VERILOG_DoubleClick = Edit
VERILOG_CustomDoubleClick = 
SYSTEMVERILOG_DoubleClick = Edit
SYSTEMVERILOG_CustomDoubleClick = 
VHDL_DoubleClick = Edit
VHDL_CustomDoubleClick = 
PSL_DoubleClick = Edit
PSL_CustomDoubleClick = 
TEXT_DoubleClick = Edit
TEXT_CustomDoubleClick = 
SYSTEMC_DoubleClick = Edit
SYSTEMC_CustomDoubleClick = 
TCL_DoubleClick = Edit
TCL_CustomDoubleClick = 
MACRO_DoubleClick = Edit
MACRO_CustomDoubleClick = 
VCD_DoubleClick = Edit
VCD_CustomDoubleClick = 
SDF_DoubleClick = Edit
SDF_CustomDoubleClick = 
XML_DoubleClick = Edit
XML_CustomDoubleClick = 
LOGFILE_DoubleClick = Edit
LOGFILE_CustomDoubleClick = 
UCDB_DoubleClick = Edit
UCDB_CustomDoubleClick = 
TDB_DoubleClick = Edit
TDB_CustomDoubleClick = 
UPF_DoubleClick = Edit
UPF_CustomDoubleClick = 
PCF_DoubleClick = Edit
PCF_CustomDoubleClick = 
PROJECT_DoubleClick = Edit
PROJECT_CustomDoubleClick = 
VRM_DoubleClick = Edit
VRM_CustomDoubleClick = 
DEBUGDATABASE_DoubleClick = Edit
DEBUGDATABASE_CustomDoubleClick = 
DEBUGARCHIVE_DoubleClick = Edit
DEBUGARCHIVE_CustomDoubleClick = 
Project_Major_Version = 2020
Project_Minor_Version = 1
'''
main()