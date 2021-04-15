function bSuccessful = fnParadigmHandMappingInit()
%
% Copyright (c) 2008 Shay Ohayon, California Institute of Technology.
% This file is a part of a free software. you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation (see GPL.txt)

global g_strctParadigm g_strctStimulusServer g_strctPTB g_strctAppConfig g_strctPlexon g_strctLocalExperimentRecording g_strctSystemCodes g_strctCycle g_strctRealTimeStatServer
% Edits By Josh



g_strctParadigm.m_strctSubject = g_strctAppConfig.m_strctSubject;
g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath = [g_strctAppConfig.m_strctDirectories.m_strLogFolder, g_strctParadigm.m_strctSubject.m_strExperimentName];
mkdir(g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath);
g_strctParadigm.m_strctSubject.m_strExperimentHistoryFileName = [g_strctParadigm.m_strctSubject.m_strExperimentHistoryPath,'\',g_strctParadigm.m_strctSubject.m_strExperimentName];
g_strctParadigm.m_strctSubject.m_iBackupIter = 1;
g_strctParadigm.m_fStartTime = GetSecs;
g_strctLocalExperimentRecording = cell(20000,1);
g_strctParadigm.m_iLocalExperimentIter = 1;
g_strctParadigm.m_bSetDynamicTrialMode = 1;
% Default initializations...
g_strctParadigm.m_iMachineState = 0; % Always initialize first state to zero.

g_strctParadigm.m_iUserCommentIteration = 1;

%{
g_strctParadigm.m_cPresetColors{1,1} = [255, 0, 0];
g_strctParadigm.m_cPresetColors{1,2} = [0,154,38]; 
g_strctParadigm.m_cPresetColors{2,1} = [0, 252, 0];
g_strctParadigm.m_cPresetColors{2,2} = [255, 0, 55];
g_strctParadigm.m_cPresetColors{3,1} = [148, 0, 255];
g_strctParadigm.m_cPresetColors{3,2} = [52, 209, 0]; 
g_strctParadigm.m_bInvertPresetColors = false;
%}

				
g_strctParadigm.m_cPresetColors{1,1} = [255, 0, 0];
g_strctParadigm.m_cPresetColors{1,2} = [0,154,38]; 
g_strctParadigm.m_cPresetColors{2,1} = [0,154,38]; 
g_strctParadigm.m_cPresetColors{2,2} = [255, 0, 0]; 
g_strctParadigm.m_cPresetColors{3,1} = [0, 252, 0];
g_strctParadigm.m_cPresetColors{3,2} = [255, 0, 55];
g_strctParadigm.m_cPresetColors{4,1} = [255, 0, 55];
g_strctParadigm.m_cPresetColors{4,2} = [0, 252, 0];
g_strctParadigm.m_cPresetColors{5,1} = [148, 0, 255];
g_strctParadigm.m_cPresetColors{5,2} = [52, 209, 0];
g_strctParadigm.m_cPresetColors{6,1} = [52, 209, 0]; 	
g_strctParadigm.m_cPresetColors{6,2} = [148, 0, 255]; 	
g_strctParadigm.m_cPresetColors{7,1} = [255, 255, 255];
g_strctParadigm.m_cPresetColors{7,2} = [0, 0, 0];
g_strctParadigm.m_cPresetColors{8,1} = [0, 0, 0]; 	
g_strctParadigm.m_cPresetColors{8,2} = [255, 255, 255]; 	
				

g_strctParadigm.m_cParadigmSpecificKeyCodes{1,1} = 32;
g_strctParadigm.m_cParadigmSpecificKeyCodes{1,2} = 'g_strctParadigm.m_strCurrentlySelectedVariable = ''StimulusPosition'';';
g_strctParadigm.m_cParadigmSpecificKeyCodes{2,1} = 80;
g_strctParadigm.m_cParadigmSpecificKeyCodes{2,2} = 'g_strctParadigm.m_iCurrentBlockIndexInOrderList = 1;feval(g_strctParadigm.m_strCallbacks,''JumpToBlock'');feval(g_strctParadigm.m_strCallbacks,''StaticBarPanel'')';
%{
g_strctParadigm.m_cParadigmSpecificKeyCodes{2,1} = 80;
g_strctParadigm.m_cParadigmSpecificKeyCodes{2,2} = 'feval(g_strctParadigm.m_strCallbacks,''StaticBarPanel'')';
%}




if fnParadigmToKofikoComm('IsTouchMode')
    bSuccessful = false;
    return;
end

g_strctParadigm.m_strBlockDoneAction = 'Repeat Same Order';
g_strctParadigm.m_iNumTimesBlockShown = 0;
g_strctParadigm.m_iCurrentBlockIndexInOrderList = 1;
g_strctParadigm.m_iCurrentMediaIndexInBlockList = 1;
g_strctParadigm.m_iCurrentOrder = 1;
g_strctParadigm.m_bBlockLooping = true;

%g_strctParadigm.m_bDoNotDrawThisCycle = false;

% Finite State Machine related parameters
g_strctParadigm.m_bRandom = g_strctParadigm.m_fInitial_RandomStimuli; 

g_strctParadigm.m_bRepeatNonFixatedImages = false;

iSmallBuffer = 500;
iLargeBuffer = 50000;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'JuiceTimeMS', g_strctParadigm.m_fInitial_JuiceTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'JuiceTimeHighMS', g_strctParadigm.m_fInitial_JuiceTimeHighMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GazeTimeMS', g_strctParadigm.m_fInitial_GazeTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GazeTimeLowMS', g_strctParadigm.m_fInitial_GazeTimeLowMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BlinkTimeMS', g_strctParadigm.m_fInitial_BlinkTimeMS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'PositiveIncrement', g_strctParadigm.m_fInitial_PositiveIncrementPercent, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'SyncTime', [0,0,0], iLargeBuffer);

% Stimulus related parameters. These will be sent to the stimulus server,
% so make sure all required stimulus parameters (that can change) are
% represented in this structure.

g_strctParadigm.m_iPhotoDiodeWindowPix = 0; % Very important if you want to get a signal from the photodiode to plexon


try
	g_strctParadigm.m_strctMasterColorTable = load('colorVals.mat');
	%g_strctParadigm.m_strctPresetColorTable = load('presetColors.mat');
catch
	warning('could not find color file in root folder, specify location')
	g_strctParadigm.m_strctMasterColorTable = uiopen;
	%warning('could not find preset color file in root folder, specify location')
	%g_strctParadigm.m_strctPresetColorTable = uiopen;
end

g_strctParadigm.m_aiCalibratedBackgroundColor = [49670  49841  49965];

% general stuff
g_strctParadigm.m_strCurrentlySelectedBlock = 'StaticBar';
 g_strctParadigm.m_strHandMappingCommandToStatServer = [];
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BlinkTimeMS', g_strctParadigm.m_fInitial_BlinkTimeMS, iSmallBuffer);
g_strctParadigm.m_fBlinkTimer = 0;
g_strctParadigm.m_bReverseCycleStimulusOrientation = 0;
g_strctParadigm.m_bCycleStimulusOrientation = 0;
g_strctParadigm.m_iOrientationBin = 0;
g_strctParadigm.m_iTrialSaveInterval = 1000;
g_strctParadigm.m_iExperimentBackupIter = 1;
g_strctParadigm.m_iCLUTOffset = 2;
g_strctParadigm.m_bUseCalibratedColors =  0; 
g_strctParadigm.m_bUsePresetColors =  0; 
g_strctParadigm.m_bCycleColors = 0;
g_strctParadigm.m_bRealTimeCycleColors = 0;
g_strctParadigm.m_iSelectedColorIndex = 1;
g_strctParadigm.m_iSelectedSaturationIndex = 1;
g_strctParadigm.m_bColorUpdated = 0;
g_strctParadigm.m_fLastColorCycleUpdate = GetSecs();
g_strctParadigm.m_iSelectedColorList = 1;
g_strctParadigm.m_strctColorPicker.m_aiColorPickerRect = [1300,800,1600,1100];
g_strctParadigm.m_strctColorPicker.m_bShowColorPicker = 1;
g_strctParadigm.m_strctGammaCorrectedLookupTable = load('gammaCorrectedLookUpTable');
g_strctParadigm.m_strctConversionMatrices = load('ConversionMatrices');
g_strctParadigm.m_bUseCartesianCoordinates = 0;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CartesianXCoord', g_strctParadigm.m_fInitial_CartesianXCoord, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CartesianYCoord', g_strctParadigm.m_fInitial_CartesianYCoord, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CartesianZCoord', g_strctParadigm.m_fInitial_CartesianZCoord, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DKLRadius', g_strctParadigm.m_fInitial_DKLRadius, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DKLAzimuthSteps', g_strctParadigm.m_fInitial_DKLAzimuthSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DKLElevation', g_strctParadigm.m_fInitial_DKLElevation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ShiftOffsetDegrees', g_strctParadigm.m_fInitial_ShiftOffsetDegrees, iSmallBuffer);
g_strctParadigm.m_iCurrentlySelectedDKLCoordinateID = 1;
g_strctParadigm.m_bFlipForegroundBackground = false;
g_strctParadigm.m_bPhaseShiftOffset = false;


%g_strctParadigm= fnTsAddVar(g_strctParadigm, 'CartesianZCoord', g_strctParadigm.m_fInitial_SelectedColorList, iSmallBuffer);


g_strctParadigm.m_iSelectedColorList = find(strcmp(fields(g_strctParadigm.m_strctMasterColorTable), g_strctParadigm.m_strInitial_SelectedColorList));
[a2cCharMatrix, g_strctParadigm.m_strctMasterColorTableLookup] = fnStructToCharShort(g_strctParadigm.m_strctMasterColorTable);

g_strctParadigm.m_strctCurrentSaturation = g_strctParadigm.m_strctMasterColorTable.(g_strctParadigm.m_strctMasterColorTableLookup{g_strctParadigm.m_iSelectedColorList});



g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusPosition', g_strctParadigm.m_afInitial_StimulusPosition, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'CurrStimulusIndex', 0, iLargeBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FixationSizePix', g_strctParadigm.m_fInitial_FixationSizePix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'FixationSpotPix', g_strctStimulusServer.m_aiScreenSize(3:4)/2, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GazeBoxPix', g_strctParadigm.m_fInitial_GazeBoxPix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusPos', g_strctStimulusServer.m_aiScreenSize(3:4)/2, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusSizePix', g_strctParadigm.m_fInitial_StimulusSizePix, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusON_MS', g_strctParadigm.m_fInitial_StimulusON_MS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StimulusOFF_MS', g_strctParadigm.m_fInitial_StimulusOFF_MS, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ColorCycleRate', g_strctParadigm.m_fInitial_ColorCycleRate, iSmallBuffer);




% For hand mapping
%% Static Bar Stimuli
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarWidth', g_strctParadigm.m_fInitial_StaticBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarLength', g_strctParadigm.m_fInitial_StaticBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarOrientation', g_strctParadigm.m_fInitial_StaticBarOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarMoveDistance', g_strctParadigm.m_fInitial_StaticBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarStimulusArea', g_strctParadigm.m_fInitial_StaticBarStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarStimulusRed', g_strctParadigm.m_fInitial_StaticBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarStimulusGreen', g_strctParadigm.m_fInitial_StaticBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarStimulusBlue', g_strctParadigm.m_fInitial_StaticBarStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarBackgroundRed', g_strctParadigm.m_fInitial_StaticBarBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarBackgroundGreen', g_strctParadigm.m_fInitial_StaticBarBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarBackgroundBlue', g_strctParadigm.m_fInitial_StaticBarBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarBlur', g_strctParadigm.m_fInitial_StaticBarBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarBlurSteps', g_strctParadigm.m_fInitial_StaticBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarMoveSpeed', g_strctParadigm.m_fInitial_StaticBarMoveSpeed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'StaticBarStimulusPresetColor', g_strctParadigm.m_fInitial_StaticBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm.bReverse = 0;
g_strctParadigm.m_fLastBarPositionOffset = 0;
g_strctParadigm.m_fLastBarMovementDirection = 1; % 1 or -1
g_strctParadigm.m_bUsePlainBarPresetColors = 0;





%% Moving Bar Stimuli
g_strctParadigm.m_iNumOrientationBins = 20;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarNumberOfBars', g_strctParadigm.m_fInitial_MovingBarNumberOfBars, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarWidth', g_strctParadigm.m_fInitial_MovingBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarLength', g_strctParadigm.m_fInitial_MovingBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarOrientation', g_strctParadigm.m_fInitial_MovingBarOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarMoveDistance', g_strctParadigm.m_fInitial_MovingBarMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusArea', g_strctParadigm.m_fInitial_MovingBarStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusRed', g_strctParadigm.m_fInitial_MovingBarStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusGreen', g_strctParadigm.m_fInitial_MovingBarStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusBlue', g_strctParadigm.m_fInitial_MovingBarStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBackgroundRed', g_strctParadigm.m_fInitial_MovingBarBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBackgroundGreen', g_strctParadigm.m_fInitial_MovingBarBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBackgroundBlue', g_strctParadigm.m_fInitial_MovingBarBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBlur', g_strctParadigm.m_fInitial_MovingBarBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarBlurSteps', g_strctParadigm.m_fInitial_MovingBarBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusOffTime', g_strctParadigm.m_fInitial_MovingBarStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusOnTime', g_strctParadigm.m_fInitial_MovingBarStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MovingBarStimulusPresetColor', g_strctParadigm.m_fInitial_MovingBarStimulusPresetColor, iSmallBuffer);
g_strctParadigm.m_bClipStimulusOutsideStimArea = true;
g_strctParadigm.m_bUseMovingBarPresetColors = 0;
g_strctParadigm.m_bFlipForegroundBackgroundMovingBar = false;

%% For Gabors
g_strctParadigm.m_strctGaborParams.m_bNonsymmetric = g_strctParadigm.m_fInitial_Gabor_Nonsymmetric;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBarWidth', g_strctParadigm.m_fInitial_GaborBarWidth, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBarLength', g_strctParadigm.m_fInitial_GaborBarLength, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborOrientation', g_strctParadigm.m_fInitial_GaborOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusArea', g_strctParadigm.m_fInitial_GaborStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborMoveDistance', g_strctParadigm.m_fInitial_GaborMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusRed', g_strctParadigm.m_fInitial_GaborStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusGreen', g_strctParadigm.m_fInitial_GaborStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusBlue', g_strctParadigm.m_fInitial_GaborStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBackgroundRed', g_strctParadigm.m_fInitial_GaborBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBackgroundGreen', g_strctParadigm.m_fInitial_GaborBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborBackgroundBlue', g_strctParadigm.m_fInitial_GaborBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborPhase', g_strctParadigm.m_fInitial_GaborPhase, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborFreq', g_strctParadigm.m_fInitial_GaborFreq, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborContrast', g_strctParadigm.m_fInitial_GaborContrast, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborSigma', g_strctParadigm.m_fInitial_GaborSigma, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborFreq', g_strctParadigm.m_fInitial_GaborFreq, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'GaborStimulusPresetColor', g_strctParadigm.m_fInitial_GaborStimulusPresetColor, iSmallBuffer);

g_strctParadigm.m_bUseGaborPresetColors = 0;

	


g_strctParadigm.m_strctGaborParams.m_bReversePhaseDirection = 0;
g_strctParadigm.m_strctGaborParams.m_bGaborsInitialized = 0;
g_strctParadigm.m_strctGaborParams.m_fLastGaborPhase = 0;

% For discs
g_strctParadigm.m_strctHandMappingParams.m_bPerfectCircles = 1;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscNumberOfDiscs', g_strctParadigm.m_fInitial_DiscNumberOfDiscs, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscDiameter', g_strctParadigm.m_fInitial_DiscDiameter, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscOrientation', g_strctParadigm.m_fInitial_DiscOrientation, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscMoveDistance', g_strctParadigm.m_fInitial_DiscMoveDistance, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscMoveSpeed', g_strctParadigm.m_fInitial_DiscMoveSpeed, iSmallBuffer);

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusArea', g_strctParadigm.m_fInitial_DiscStimulusArea, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusRed', g_strctParadigm.m_fInitial_DiscStimulusRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusGreen', g_strctParadigm.m_fInitial_DiscStimulusGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusBlue', g_strctParadigm.m_fInitial_DiscStimulusBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundRed', g_strctParadigm.m_fInitial_DiscBackgroundRed, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundGreen', g_strctParadigm.m_fInitial_DiscBackgroundGreen, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBackgroundBlue', g_strctParadigm.m_fInitial_DiscBackgroundBlue, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBlur', g_strctParadigm.m_fInitial_DiscBlur, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscBlurSteps', g_strctParadigm.m_fInitial_DiscBlurSteps, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusOffTime', g_strctParadigm.m_fInitial_DiscStimulusOffTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusOnTime', g_strctParadigm.m_fInitial_DiscStimulusOnTime, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'DiscStimulusPresetColor', g_strctParadigm.m_fInitial_DiscStimulusPresetColor, iSmallBuffer);
g_strctParadigm.m_strctHandMappingParameters.m_bDiscRandomStimulusOrientation = 0;
g_strctParadigm.m_bRandomDiscStimulusPosition = 0;
g_strctParadigm.m_bUseDiscPresetColors = 0;

%{
g_strctParadigm.m_strctGaborParams.m_afDestinationRectangle = [g_strctParadigm.m_afInitial_StimulusPosition(1) - g_strctParadigm.m_fInitial_StimulusArea,...
																g_strctParadigm.m_afInitial_StimulusPosition(2) - g_strctParadigm.m_fInitial_StimulusArea,...
																g_strctParadigm.m_afInitial_StimulusPosition(1) + g_strctParadigm.m_fInitial_StimulusArea,...
																g_strctParadigm.m_afInitial_StimulusPosition(2)  g_strctParadigm.m_fInitial_StimulusArea];
%}

% Seed the randomness
g_strctParadigm.g_fRandomSeedWaitMS = g_strctParadigm.m_fInitial_RandomSeedWaitMS;
ClockRandSeed;
g_strctParadigm.m_fLastRandSeed = GetSecs();


% For tuning function
g_strctParadigm.m_bRandomColor = g_strctParadigm.m_fInitial_RandomColorOrder;
g_strctParadigm.m_bReverseColorOrder = g_strctParadigm.m_fInitial_ReverseColorOrder;
g_strctParadigm.m_bRandomColorOrder = g_strctParadigm.m_fInitial_RandomColorOrder;
g_strctParadigm.m_strctTuningFunctionParams.m_afMasterClut = zeros(256,3);
g_strctParadigm.m_strctTuningFunctionParams.m_strBGColor = g_strctParadigm.m_strInitial_DefaultBGColor;
g_strctParadigm.m_strctTuningFunctionParams.m_iBGColorRGBIndex = g_strctParadigm.m_fInitial_BGColorRGBIndex;
g_strctParadigm.m_strctTuningFunctionStats.m_afPolarPlottingHolder = {}; % Holder for polar plotting data if it is cleared

g_strctPlexon = [];

% For orientation Tuning
g_strctParadigm.m_bReverseOrientationOrder = 0;
g_strctParadigm.m_bRandomOrientation = 0;
g_strctParadigm.m_fOrientationID = 0;
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NumberOfOrientationsToTest', g_strctParadigm.m_fInitial_NumberOfOrientationsToTest, iSmallBuffer);

% For position Tuning
g_strctParadigm.m_strctPositionTuningFunction.m_fNumFrames = 16;
g_strctParadigm.m_strctPositionTuningFunction.m_fStimulusOnTime = 200;
g_strctParadigm.m_strctPositionTuningFunction.m_fStimulusOffTime = 200;

% For PTB Plotting

g_strctPlexon.m_iPolarUpdateMS = g_strctParadigm.m_fInitial_PolarUpdateMS;
g_strctParadigm.m_bPolarPlot = g_strctParadigm.m_fInitial_PolarPlot;
g_strctParadigm.m_bUpdatePolar = 0;

g_strctPlexon.m_strctStatistics.m_afPolarPlottingArray = zeros(20,2);
g_strctPlexon.m_strctStatistics.m_afPolarColors  = g_strctParadigm.m_afInitial_PolarColors;
g_strctPlexon.m_strctStatistics.m_afPolarOutlineColors  = g_strctParadigm.m_afInitial_PolarOutlineColors;
g_strctPlexon.m_strctStatistics.m_afPolarRect = g_strctParadigm.m_afInitial_PolarPosition;



% Neutralize any previous Cluts we may have loaded
fnParadigmToStimulusServer('LoadDefaultClut');

try
	g_strctParadigm.m_aiSpikeChannels = g_strctParadigm.m_afInitial_SpikeChannels;
catch
	g_strctParadigm.m_aiSpikeChannels = g_strctParadigm.m_fInitial_SpikeChannels;
end

fCurrTime = GetSecs();
% Plexony stuff

g_strctPlexon.m_aiTrials = [];
g_strctPlexon.m_aiTrialsIteration = 1;
g_strctPlexon.m_bTrialInTempBuffer = 0;
g_strctPlexon.m_bDrawToPTBScreen = 1;

%[g_strctPlexon.m_iServerID] = PL_InitClient(0);


%if isempty(g_strctPlexon.m_iServerID)
	% Do something. I dunno. Cry, maybe.
%end
%g_strctPlexon.m_iSpikeUpdateHz = g_strctParadigm.m_fInitial_SpikeUpdateHz;
g_strctPlexon.m_iSpikeUpdateHz = 10;
g_strctPlexon.m_strctStatistics.m_iHeatUpdateHz = 1;
g_strctPlexon.m_strctStatistics.m_fLastHeatUpdate = fCurrTime;
g_strctPlexon.m_strctStatistics.m_iPolarUpdateHz = 1;
g_strctPlexon.m_strctStatistics.m_fLastPolarUpdate = fCurrTime;
g_strctPlexon.m_strctStatistics.m_iRasterUpdateHz = 10;
g_strctPlexon.m_strctStatistics.m_fLastRasterUpdate = fCurrTime;
g_strctPlexon.m_strctStatistics.m_fRasterTrailMS = 30000;
g_strctPlexon.m_fLastTimeStampSync = zeros(1,2);
g_strctPlexon.m_strctStatistics.m_aiRasterColors = [0,255,0];
g_strctPlexon.m_strctStatistics.m_aiRasterPlottingRect = [1200,300,1500,400];

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'rasterPlotX', 1200, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'rasterPlotY', 300, iSmallBuffer);

% Get the current server time
fnDAQWrapper('StrobeWord', g_strctSystemCodes.m_iSync);
g_strctCycle.m_fSyncTimer = fCurrTime;
if g_strctRealTimeStatServer.m_bConnected
            mssend(g_strctRealTimeStatServer.m_iSocket,{'SyncWithKofiko',g_strctCycle.m_fSyncTimer});
            %afCycleDebugTimers(12) = GetSecs();
            
end

[g_strctPlexon.m_fLastPlexonUpdate] = fCurrTime;

g_strctParadigm.m_bRasterPlot = 1;

g_strctParadigm.m_bHeatPlot = 0;


g_strctParadigm.m_bPolarPlot = 0;

g_strctPlexon.m_afRollingSpikeBuffer.Buf = zeros(50000,4);
g_strctPlexon.m_afRollingSpikeBuffer.BufID = 0;

g_strctPlexon.m_afWaveFormBuffer.m_iTrialsToKeepInBuffer = 400;
g_strctPlexon.m_afSpikeBuffer.m_iTrialsToKeepInBuffer = 400;
  
g_strctPlexon.m_afWaveFormBuffer.m_aiCircularBufferIndices = ones(20,1);
g_strctPlexon.m_afSpikeBuffer.m_aiCircularBufferIndices = ones(20,1);

g_strctPlexon.m_afSpikeBuffer.m_aiCircularBuffer = zeros(20,g_strctPlexon.m_afWaveFormBuffer.m_iTrialsToKeepInBuffer,50,4);
g_strctPlexon.m_afWaveFormBuffer.m_aiCircularBuffer = zeros(20,g_strctPlexon.m_afWaveFormBuffer.m_iTrialsToKeepInBuffer,50,32);

g_strctPlexon.m_strctStatistics.m_hHistogram = [];
g_strctPlexon.m_strctStatistics.m_iPreTrialTime = -.05;
g_strctPlexon.m_strctStatistics.m_iPostTrialTime = .200;



g_strctParadigm = fnTsAddVar(g_strctParadigm, 'TrialsForPlotting', g_strctParadigm.m_fInitial_TrialsForPlotting, iSmallBuffer);






g_strctParadigm.m_iInitialIndexInColorList = 1;

% Set the initial variable as the stimulus position. This will be changed if the mouse is dragged on the screen
g_strctParadigm.m_strCurrentlySelectedVariable = 'StimulusPosition';
g_strctPTB.m_variableUpdating = false;

%g_strctParadigm = fnTsAddVar(g_strctParadigm, 'BackgroundColor',  [g_strctParadigm.m_fInitial_BackgroundRed,...
% g_strctParadigm.m_fInitial_BackgroundGreen, g_strctParadigm.m_fInitial_BackgroundBlue], iSmallBuffer);

 
 
 g_strctPTB.g_strctStimulusServer.m_RefreshRateMS = fnParadigmToKofikoComm('GetRefreshRate');
g_strctPTB.m_strctControlInputs.m_bLastStimulusPositionCheck = 0;
% Start the object at the fovea (center of screen). This is handled separately from the other variables during the paradigm
g_strctParadigm.m_aiCenterOfStimulus(1) = g_strctStimulusServer.m_aiScreenSize(3)/2;
g_strctParadigm.m_aiCenterOfStimulus(2) = g_strctStimulusServer.m_aiScreenSize(4)/2;
g_strctParadigm.g_strctStimulusServer.m_aiScreenSize = g_strctStimulusServer.m_aiScreenSize;

g_strctParadigm.m_aiStimulusRect(1) = g_strctParadigm.m_aiCenterOfStimulus(1)-(squeeze(g_strctParadigm.StaticBarStimulusArea.Buffer(1,:,g_strctParadigm.StaticBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(2) = g_strctParadigm.m_aiCenterOfStimulus(2)-(squeeze(g_strctParadigm.StaticBarStimulusArea.Buffer(1,:,g_strctParadigm.StaticBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(3) = g_strctParadigm.m_aiCenterOfStimulus(1)+(squeeze(g_strctParadigm.StaticBarStimulusArea.Buffer(1,:,g_strctParadigm.StaticBarStimulusArea.BufferIdx)/2));
g_strctParadigm.m_aiStimulusRect(4) = g_strctParadigm.m_aiCenterOfStimulus(2)+(squeeze(g_strctParadigm.StaticBarStimulusArea.Buffer(1,:,g_strctParadigm.StaticBarStimulusArea.BufferIdx)/2));


g_strctPTB.m_stimulusAreaUpdating = false;


g_strctParadigm.m_bRandomStimulusPosition = false;
g_strctParadigm.m_bRandomStimulusOrientation = false;



g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicroStimulationAmplitude', 0, iSmallBuffer);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'MicrostimDelayMS', 0, iSmallBuffer);

bForceStereoOnMonocularInitialValue = false;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ForceStereoOnMonocularLists', bForceStereoOnMonocularInitialValue, iSmallBuffer);

%{
g_strctParadigm.m_strctSavedParam.m_pt2fStimulusPosition = fnTsGetVar('g_strctParadigm','StimulusPos');
g_strctParadigm.m_strctSavedParam.m_fTheta = fnTsGetVar('g_strctParadigm','RotationAngle');
g_strctParadigm.m_strctSavedParam.m_fSize = fnTsGetVar('g_strctParadigm','StimulusSizePix');
%}
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'Trials',[0;0;0;0;0;0;0],iLargeBuffer);

g_strctParadigm.m_strctCurrentTrial = [];
g_strctParadigm.m_bShowPhotodiodeRect = g_strctParadigm.m_fInitial_ShowPhotodiodeRect;

g_strctParadigm = fnTsAddVar(g_strctParadigm, 'ImageList', '',20);
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'Designs', {},20);

g_strctParadigm.m_iNumStimuli = 0;
g_strctParadigm.m_bStimulusDisplayed = false;
g_strctParadigm.m_aiCurrentRandIndices = [];

g_strctParadigm.m_strSavedImageList = '';
g_strctParadigm.m_fInsideGazeRectTimer = 0; 
g_strctParadigm.m_bUpdateFixationSpot = false;
g_strctParadigm.m_bUpdateStimulusPos = false;

g_strctParadigm.m_strLocalStereoMode = 'Side by Side (Large)';
    
g_strctParadigm.m_strState = 'Doing Nothing;';

g_strctParadigm.m_strImageList = '';
% g_strctParadigm.m_strOnlyFacesImageList = g_strctParadigm.m_strInitial_FacesImageList;
% g_strctParadigm.m_strFOBImageList = g_strctParadigm.m_strInitial_FOBImageList;

g_strctParadigm.m_bDisplayStimuliLocally = true;
g_strctParadigm.m_bMovieInitialized = false;

g_strctParadigm.m_iRandFixCounter = 0;
g_strctParadigm.m_bRandFixPos = g_strctParadigm.m_fInitial_RandomPosition;
g_strctParadigm.m_fRandFixPosMin = g_strctParadigm.m_fInitial_RandomPositionMin;
g_strctParadigm.m_fRandFixPosMax = g_strctParadigm.m_fInitial_RandomPositionMax;
g_strctParadigm.m_fRandFixRadius = g_strctParadigm.m_fInitial_RandomPositionRadius;
g_strctParadigm.m_iRandFixCounterMax = g_strctParadigm.m_fRandFixPosMin + round(rand() * (g_strctParadigm.m_fRandFixPosMax-g_strctParadigm.m_fRandFixPosMin));
g_strctParadigm.m_bRandFixSyncStimulus = true;

g_strctParadigm.m_bHideStimulusWhenNotLooking = g_strctParadigm.m_fInitial_HideStimulusWhenNotLooking;
g_strctParadigm.m_fLastFixatedTimer = 0; 

g_strctParadigm.m_a2bStimulusCategory = [];
g_strctParadigm.m_acCatNames = [];

% Initialize Dynamic Juice Reward System
g_strctParadigm.m_strctDynamicJuice.m_fTotalFixationTime = 0;
g_strctParadigm.m_strctDynamicJuice.m_fTotalNonFixationTime = 0;
g_strctParadigm.m_strctDynamicJuice.m_iState = 1;
g_strctParadigm.m_strctDynamicJuice.m_iFixationCounter = 0;

g_strctParadigm.m_bPausedDueToMotion = false;


acFieldNames = fieldnames(g_strctParadigm);
acFavroiteLists = cell(1,0);
iListCounter = 1;
for k=1:length(acFieldNames)
    if strncmpi(acFieldNames{k},'m_strInitial_FavroiteList',25)
        strImageListFileName = getfield(g_strctParadigm,acFieldNames{k});
        if exist(strImageListFileName,'file')
           acFavroiteLists{iListCounter} = strImageListFileName;
           iListCounter = iListCounter + 1;
        end
    end
end
% Changelog 10/21/13 josh - initializes fit to screen parameter
g_strctParadigm.m_bFitToScreen = g_strctParadigm.m_fInitial_FitToScreen;

% End Changelog
g_strctParadigm.m_bParameterSweep = g_strctParadigm.m_fInitial_ParameterSweep;
%g_strctParadigm.m_iParameterSweepMode = 1;

g_strctParadigm.m_astrctParameterSweepModes(1).m_strName = 'Fixed';
g_strctParadigm.m_astrctParameterSweepModes(1).m_afX  = 0;
g_strctParadigm.m_astrctParameterSweepModes(1).m_afY  = 0;
g_strctParadigm.m_astrctParameterSweepModes(1).m_afSize  = [];
g_strctParadigm.m_astrctParameterSweepModes(1).m_afTheta  = [];

g_strctParadigm.m_astrctParameterSweepModes(2).m_strName = '7x7 Position Only';
g_strctParadigm.m_astrctParameterSweepModes(2).m_afX  = [-300:100:300];
g_strctParadigm.m_astrctParameterSweepModes(2).m_afY  = [-300:100:300];
g_strctParadigm.m_astrctParameterSweepModes(2).m_afSize  = [];
g_strctParadigm.m_astrctParameterSweepModes(2).m_afTheta  = [];

g_strctParadigm.m_astrctParameterSweepModes(3).m_strName = '7x7x3 Position & Scale';
g_strctParadigm.m_astrctParameterSweepModes(3).m_afX  = [-300:100:300];
g_strctParadigm.m_astrctParameterSweepModes(3).m_afY  = [-300:100:300];
g_strctParadigm.m_astrctParameterSweepModes(3).m_afSize  = [32 64 128];
g_strctParadigm.m_astrctParameterSweepModes(3).m_afTheta  = [];

g_strctParadigm.m_astrctParameterSweepModes(4).m_strName = '21x21 Position Only';
g_strctParadigm.m_astrctParameterSweepModes(4).m_afX  = -400:40:400;
g_strctParadigm.m_astrctParameterSweepModes(4).m_afY  = -300:30:300;
g_strctParadigm.m_astrctParameterSweepModes(4).m_afSize  = [];
g_strctParadigm.m_astrctParameterSweepModes(4).m_afTheta  = [];

g_strctParadigm.m_astrctParameterSweepModes(5).m_strName = '21x21x3 Position Only';
g_strctParadigm.m_astrctParameterSweepModes(5).m_afX  = -400:40:400;
g_strctParadigm.m_astrctParameterSweepModes(5).m_afY  = -300:30:300;
g_strctParadigm.m_astrctParameterSweepModes(5).m_afSize  = [32 64 128];
g_strctParadigm.m_astrctParameterSweepModes(5).m_afTheta  = [];

% Search for noise patterns...
astrctNoisePatternsFiles = dir('\\kofiko-23b\StimulusSet\NoisePatterns\*.mat');
g_strctParadigm.m_acNoisePatternsFiles = {astrctNoisePatternsFiles.name};
g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NoiseOverlayActive', false, iSmallBuffer);
if ~isempty(g_strctParadigm.m_acNoisePatternsFiles) && exist(['\\kofiko-23b\StimulusSet\NoisePatterns\\',g_strctParadigm.m_acNoisePatternsFiles{1}],'file')
    try
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NoiseFile', g_strctParadigm.m_acNoisePatternsFiles{1}, 20);
    strctTmp = load(['\\kofiko-23b\StimulusSet\NoisePatterns\\',g_strctParadigm.m_acNoisePatternsFiles{1}]);
    g_strctParadigm.m_a3fRandPatterns = strctTmp.a3fRand;
    g_strctParadigm.m_strctNoiseOverlay.m_iNumNoisePatterns = size(g_strctParadigm.m_a3fRandPatterns,3);
    catch
        g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NoiseFile', '', 20);
        g_strctParadigm.m_strctNoiseOverlay.m_iNumNoisePatterns = 0 ;
    end
    
else
    g_strctParadigm = fnTsAddVar(g_strctParadigm, 'NoiseFile', '', 20);
    g_strctParadigm.m_strctNoiseOverlay.m_iNumNoisePatterns = 0 ;
end
g_strctParadigm.m_strctNoiseOverlay.m_iNoiseIndex = 0;
g_strctParadigm.m_strctNoiseOverlay.m_fNoiseIntensity = 0;

g_strctParadigm.m_acImageFileNames = [];


g_strctParadigm.m_strctMiroSctim.m_bActive = false;


TRIAL_START_CODE = 32700;
TRIAL_END_CODE = 32699;
TRIAL_ALIGN_CODE = 32698;
TRIAL_OUTCOME_MISS = 32695;
TRIAL_INCORRECT_FIX = 32696;
TRIAL_CORRECT_FIX = 32697;

strctDesign.TrialStartCode = TRIAL_START_CODE;
strctDesign.TrialEndCode = TRIAL_END_CODE;
strctDesign.TrialAlignCode = TRIAL_ALIGN_CODE;
strctDesign.TrialOutcomesCodes = [TRIAL_OUTCOME_MISS,TRIAL_INCORRECT_FIX,TRIAL_CORRECT_FIX];
strctDesign.KeepTrialOutcomeCodes = [TRIAL_CORRECT_FIX];
strctDesign.TrialTypeToConditionMatrix = [];
strctDesign.ConditionOutcomeFilter = cell(0);
strctDesign.NumTrialsInCircularBuffer = 200;
strctDesign.TrialLengthSec = 1.1 * (g_strctParadigm.m_fInitial_StimulusON_MS+g_strctParadigm.m_fInitial_StimulusOFF_MS)/1e3; % multiple by 10% to account for possible jitter
strctDesign.Pre_TimeSec = 0.5;
strctDesign.Post_TimeSec = 0.5;
g_strctParadigm.m_strctStatServerDesign = strctDesign;
g_strctParadigm.m_bJustLoaded = true;
g_strctParadigm.m_bGUILoaded = false;
iInitialIndex = -1;
if ~isempty(g_strctParadigm.m_strInitial_DefaultImageList) && exist(g_strctParadigm.m_strInitial_DefaultImageList,'file')
   if fnLoadHandMappingDesign(g_strctParadigm.m_strInitial_DefaultImageList)
    
    for k=1:length(acFavroiteLists)
        if strcmpi(acFavroiteLists{k}, g_strctParadigm.m_strInitial_DefaultImageList)
            iInitialIndex = k;
            break;
        end
    end
    if iInitialIndex == -1
        acFavroiteLists = [g_strctParadigm.m_strInitial_DefaultImageList,acFavroiteLists];
        iInitialIndex = 1;
    end
   end
else
   % g_strctParadigm.m_strctDesign = [];
end;
g_strctParadigm.m_strWhatToReset = 'Unit';
fnInitializeHandMappingCommandStructure();
g_strctParadigm.m_acFavroiteLists = acFavroiteLists;
g_strctParadigm.m_iInitialIndexInFavroiteList = iInitialIndex;
g_strctParadigm.m_bShowWhileLoading = true;
g_strctParadigm.m_fLastStatServerMemoryDumpTS = GetSecs();
g_strctParadigm = fnCleanup(g_strctParadigm);
g_strctParadigm.m_fMaxStatServerUpdateInterval = 300;
g_strctParadigm.m_fLastStatServerUpdateTS  = GetSecs();
g_strctRealTimeStatServer.m_iLastStatServerUpdateTS = GetSecs();
g_strctRealTimeStatServer.m_iStatServerUpdateInterval = 1;
g_strctRealTimeStatServer.m_iStatServerUpdateWarningElapsedTime = [];
g_strctRealTimeStatServer.m_iStatServerUpdateWarningLeadTime = .3;
g_strctRealTimeStatServer.m_bTrialInfoWait = 0;
g_strctParadigm.m_iLastStatServerSentTrialIndex = 1;
g_strctParadigm.m_iMaxTrialsToKeepInBuffer = 4000;

%g_strctRealTimeStatServer.m_btogglePSTH = true;
if g_strctRealTimeStatServer.m_bConnected
	fnParadigmToStatServerComm('setdynamictrialmode',g_strctParadigm.m_bSetDynamicTrialMode);
end


%fnGetSpikesFromPlexon();
bSuccessful = true;
return;

function g_strctParadigm = fnCleanup(g_strctParadigm)
 
fields = fieldnames(g_strctParadigm);
idx = strfind(fields,'Initial_');
idxLogical = ~cellfun(@isempty,idx);
fieldsToRM = fields(idxLogical);
for i = 1:numel(fieldsToRM)
	g_strctParadigm.m_strctInitialValues.(fieldsToRM{i}) = g_strctParadigm.(fieldsToRM{i});
end
g_strctParadigm = rmfield(g_strctParadigm,fieldsToRM);
return;