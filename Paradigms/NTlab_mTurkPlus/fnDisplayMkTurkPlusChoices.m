function [fChoicesOnsetTS] = fnDisplayMkTurkPlusChoices(hPTBWindow, strctCurrentTrial,bFlip,bClear)
global  g_strctPTB
% Clear screen

if strctCurrentTrial.m_strctTrialParams.m_bDynamicTrial
    if g_strctPTB.m_bRunningOnStimulusServer
	fChoicesOnsetTS = fnDynamicTrial(hPTBWindow, strctCurrentTrial, bFlip, bClear);
									
    else
        fnDynamicTrial(hPTBWindow, strctCurrentTrial, bFlip, bClear);
									
    end
    return;
end	
    
return;

%function fChoicesOnsetTS = fnDynamicTrial(hPTBWindow, aiChoices, strctCurrentTrial, acMedia,bFlip,bClear,bHighlightRewardedChoices,fScale, bDrawResponseRegion)
function fChoicesOnsetTS = fnDynamicTrial(hPTBWindow, strctCurrentTrial,bFlip,bClear)
global  g_strctPTB 

if bClear && g_strctPTB.m_bRunningOnStimulusServer
	Screen('FillRect',hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundColor);
elseif bClear && ~g_strctPTB.m_bRunningOnStimulusServer
    global g_strctParadigm
	Screen('FillRect',hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.m_afLocalBackgroundColor,...
				[0 0 g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(3),...
				g_strctPTB.m_fScale*g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiStimServerScreen(4)]);

end
switch lower(strctCurrentTrial.m_strChoiceDisplayType)
	case {'disc', 'annuli', 'nestedannuli'}
		[fChoicesOnsetTS] = fnDisplayChoiceTex(strctCurrentTrial, bFlip);


end
return;

function [fChoicesOnsetTS] = fnDisplayChoiceTex(strctCurrentTrial, bFlip)
global g_strctPTB                                                                                                                                                                                                                  
if g_strctPTB.m_bRunningOnStimulusServer
global g_strctDraw
	Screen('FillRect',g_strctPTB.m_hWindow, strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundLUT);
	thisFrame = rem(strctCurrentTrial.m_iChoiceFrameCounter, strctCurrentTrial.m_iMaxFramesInChoiceEpoch);
            thisFrame(thisFrame == 0) = 1;
%{
    if strctCurrentTrial.m_bLuminanceNoiseBackground        
        thisFrame(thisFrame == 0) = 1;
		Screen('DrawTexture', g_strctPTB.m_hWindow, ...
            g_strctDraw.m_ahNoiseTextures(strctCurrentTrial.m_aiLuminanceNoisePatternID(thisFrame)), ...
            [], strctCurrentTrial.m_afChoiceRingDestinationRect );
    end

    %dbstop if warning
   % warning('stop')
    for iChoices = 1:numel(strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs)
       thisChoicesFrameID(iChoices) = ...
           g_strctDraw.m_ahChoiceDiscTextures(...
           strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs(iChoices),...
           strctCurrentTrial.thisTrialChoiceTextureOrder(strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs(iChoices),thisFrame));
    end
  	Screen('DrawTextures', g_strctPTB.m_hWindow, ...
       thisChoicesFrameID', ...
        [] ,strctCurrentTrial.m_aiChoiceScreenCoordinates');
	%{
        Screen('DrawTextures', g_strctPTB.m_hWindow, ...
        g_strctDraw.m_ahChoiceDiscTextures(...
strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs,...
        strctCurrentTrial.thisTrialChoiceTextureOrder(:,thisFrame))', ...
        [] ,strctCurrentTrial.m_aiChoiceScreenCoordinates');
        %}
	%fnDrawFixationSpot(g_strctPTB.m_hWindow, strctCurrentTrial.m_strctChoicePeriod, false, 1);
%}

    switch g_strctDraw.m_strctCurrentTrial.m_iMkTurkTaskType
        case {1,4,5}
            for i = 1:length(strctCurrentTrial.m_iMkTurkChoiceIDs)
                Screen('FillRect',g_strctPTB.m_hWindow,g_strctDraw.rectColor(strctCurrentTrial.m_iMkTurkChoiceIDs(i),:),strctCurrentTrial.m_aiChoiceScreenCoordinates(i,:));
                Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctDraw.imgcircle,g_strctDraw.imageRect,strctCurrentTrial.m_aiChoiceScreenCoordinates(i,:),0,0);
            end
        case {2,6}
%             for i = 1:length(strctCurrentTrial.m_iMkTurkChoiceIDs)
%                 Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctDraw.imgChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs(i),:),g_strctDraw.imageRect,strctCurrentTrial.m_aiChoiceScreenCoordinates(i,:));
%             end
            Screen('DrawTextures', g_strctPTB.m_hWindow, ...
               g_strctDraw.imgChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs)', ...
                [] ,strctCurrentTrial.m_aiChoiceScreenCoordinates',0,0);
        case {3,7}
%             for i = 1:length(strctCurrentTrial.m_iMkTurkChoiceIDs)
%                 Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctDraw.imgAChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs(i),:),g_strctDraw.imageRect,strctCurrentTrial.m_aiChoiceScreenCoordinates(i,:));
%             end
            Screen('DrawTextures', g_strctPTB.m_hWindow, ...
               g_strctDraw.imgAChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs)', ...
                [] ,strctCurrentTrial.m_aiChoiceScreenCoordinates',0,0);
    end
%{    
    if mod(g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol,4)<2;
        Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.Blank0, [] ,strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimWin');
        g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol = g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol+1;
    else
        Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.Blank1, [] ,strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimWin');        
        g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol = g_strctDraw.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol+1;
    end
%}    
    
    Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctDraw.achromcloud_disp(strctCurrentTrial.m_strctChoicePeriod.stimseq(strctCurrentTrial.m_iChoiceFrameCounter)), [] , strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimWin',0,0);

    ClutEncoded = BitsPlusEncodeClutRow( strctCurrentTrial.m_strctChoicePeriod.Clut );
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
	Screen('DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1],0,0 );
	Screen('Close',ClutTextureIndex);
	
    g_strctDraw.m_strctCurrentTrial.m_iChoiceFrameCounter = g_strctDraw.m_strctCurrentTrial.m_iChoiceFrameCounter + 1;
	if g_strctDraw.m_strctCurrentTrial.m_iChoiceFrameCounter > length(strctCurrentTrial.m_strctChoicePeriod.stimseq)
        g_strctDraw.m_strctCurrentTrial.m_iChoiceFrameCounter = 1;
        g_strctDraw.m_strctCurrentTrial.m_iChoiceFrameCounterResets =  g_strctDraw.m_strctCurrentTrial.m_iChoiceFrameCounterResets + 1;
    end
    %g_strctDraw.m_strctCurrentTrial.m_iChoiceFrameCounter
    if bFlip
		fChoicesOnsetTS = fnFlipWrapper(g_strctPTB.m_hWindow); % This would block the server until the next flip.
    end
    
    
else
	global g_strctParadigm
	thisFrame = rem(strctCurrentTrial.m_iLocalChoiceFrameCounter, strctCurrentTrial.m_iMaxFramesInChoiceEpoch);
		thisFrame(thisFrame == 0) = 1;
%{
	for iChoices = 1:numel(strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs)
       thisChoicesFrameID(iChoices) = ...
           g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(...
           g_strctParadigm.m_strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs(iChoices),...
           g_strctParadigm.m_strctCurrentTrial.thisTrialChoiceTextureOrder(g_strctParadigm.m_strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs(iChoices),thisFrame));
    end
	Screen('DrawTextures', g_strctPTB.m_hWindow, ...
		thisChoicesFrameID', ...
		[] ,g_strctPTB.m_fScale * strctCurrentTrial.m_aiChoiceScreenCoordinates');
		%{
		Screen('DrawTextures', g_strctPTB.m_hWindow, ...
	g_strctParadigm.m_strctChoiceVars.m_ahChoiceDiscTextures(strctCurrentTrial.m_strctChoiceVars.m_iChoiceTextureIDs, strctCurrentTrial.thisTrialChoiceTextureOrder(thisFrame))', ...
		[] ,strctCurrentTrial.m_aiChoiceScreenCoordinates');
		%}
	if g_strctParadigm.m_strctChoiceVars.m_bFrameChoiceAreas
		Screen('FrameRect', g_strctPTB.m_hWindow, [255 255 255],g_strctPTB.m_fScale * strctCurrentTrial.m_strctReward.m_aiChoiceFramingRects);
	end
%}
        
    switch g_strctParadigm.m_strctCurrentTrial.m_iMkTurkTaskType
        case {1,4,5}
            for i = 1:length(strctCurrentTrial.m_iMkTurkChoiceIDs)
                Screen('FillRect',g_strctPTB.m_hWindow,g_strctParadigm.rectColor(strctCurrentTrial.m_iMkTurkChoiceIDs(i),:),g_strctPTB.m_fScale * strctCurrentTrial.m_aiChoiceScreenCoordinates(i,:));
                Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctParadigm.imgcircle,g_strctParadigm.imageRect,g_strctPTB.m_fScale * strctCurrentTrial.m_aiChoiceScreenCoordinates(i,:),0,0);
            end
        case {2,6}
%             for i = 1:length(strctCurrentTrial.m_iMkTurkChoiceIDs)
%                 Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctParadigm.imgChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs(i),:),g_strctParadigm.imageRect,g_strctPTB.m_fScale * strctCurrentTrial.m_aiChoiceScreenCoordinates(i,:));
%             end
                Screen('DrawTextures', g_strctPTB.m_hWindow, ...
                    g_strctParadigm.imgChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs)', ...
                    g_strctParadigm.imageRect, g_strctPTB.m_fScale * strctCurrentTrial.m_aiChoiceScreenCoordinates',0,0);

        case {3,7}
%             for i = 1:length(strctCurrentTrial.m_iMkTurkChoiceIDs)
%                 Screen('DrawTexture',g_strctPTB.m_hWindow,g_strctParadigm.imgAChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs(i),:),g_strctParadigm.imageRect,g_strctPTB.m_fScale * strctCurrentTrial.m_aiChoiceScreenCoordinates(i,:));
%             end
                 Screen('DrawTextures', g_strctPTB.m_hWindow, ...
                    g_strctParadigm.imgAChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs)', ...
                    g_strctParadigm.imageRect, g_strctPTB.m_fScale * strctCurrentTrial.m_aiChoiceScreenCoordinates',0,0);
    end
%{    
    if mod(g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol,4)<2;
        Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctParadigm.Blank0, [] , g_strctPTB.m_fScale * strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimWin');
        g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol = g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol+1;
    else
        Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctParadigm.Blank1, [] , g_strctPTB.m_fScale * strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimWin');        
        g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol = g_strctParadigm.m_strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimCol+1;
    end
%}
%    Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctParadigm.achromcloud_local(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.stimseq(g_strctParadigm.m_strctCurrentTrial.m_iLocalChoiceFrameCounter)), [] , g_strctPTB.m_fScale * strctCurrentTrial.m_strctTrialParams.m_aiMkTurkCueETStimWin');
    Screen('DrawTexture', g_strctPTB.m_hWindow, g_strctParadigm.achromcloud_local(g_strctParadigm.m_strctCurrentTrial.m_strctChoicePeriod.stimseq(g_strctParadigm.m_strctCurrentTrial.m_iLocalChoiceFrameCounter)), [] , g_strctPTB.m_fScale * g_strctParadigm.m_aiETStimulusRect',0,0);
%     Screen('DrawTextures', g_strctPTB.m_hWindow, ...
%        g_strctParadigm.imgAChTexPtr(strctCurrentTrial.m_iMkTurkChoiceIDs)', ...
% 		[] ,g_strctPTB.m_fScale * strctCurrentTrial.m_aiChoiceScreenCoordinates');
	

    %fnDrawFixationSpot(g_strctPTB.m_hWindow, strctCurrentTrial.m_strctChoicePeriod, false, 1);
    fChoicesOnsetTS = nan;
    g_strctParadigm.m_strctCurrentTrial.m_iLocalChoiceFrameCounter = thisFrame + 1;
    
end
return;

%{
function [fChoicesOnsetTS] = fnDisplayChoiceRing(strctCurrentTrial, bFlip)
global g_strctPTB

if g_strctPTB.m_bRunningOnStimulusServer
    global g_strctDraw 

	% fill background color
	Screen('FillRect',g_strctPTB.m_hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.m_afBackgroundLUT);
	%Screen('DrawTexture',g_strctPTB.m_hPTBWindow,g_strctDraw.ahChoiceTexture)

	Screen('DrawTexture', g_strctPTB.m_hPTBWindow, g_strctDraw.ahChoiceTexture, [],...
							strctCurrentTrial.m_afChoiceRingDestinationRect, strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle);

	fnDrawFixationSpot(g_strctPTB.m_hPTBWindow, strctCurrentTrial.m_strctChoicePeriod, false, 1);

    ClutEncoded = BitsPlusEncodeClutRow( strctCurrentTrial.m_strctChoicePeriod.Clut );
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hPTBWindow, ClutEncoded );
	Screen('DrawTexture', g_strctPTB.m_hPTBWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
	Screen('Close',ClutTextureIndex);
	
    if bFlip
		fChoicesOnsetTS = fnFlipWrapper(g_strctPTB.m_hPTBWindow); % This would block the server until the next flip.
    end
else 
	global g_strctParadigm g_strctPTB
	Screen('FillRect',g_strctPTB.m_hPTBWindow, g_strctParadigm.m_aiLocalBackgroundColor);

	% fill background color
	% Screen('FillRect',g_strctPTB.m_hPTBWindow, strctCurrentTrial.m_strctChoicePeriod.m_afLocalBackgroundColor);
	% dbstop if warning
	% warning('stop')
	% Screen('DrawTexture',hPTBWindow,g_strctParadigm.ahChoiceTexture)


	Screen('DrawTexture', g_strctPTB.m_hPTBWindow, g_strctParadigm.ahChoiceTexture, [],...
							g_strctPTB.m_fScale * strctCurrentTrial.m_afChoiceRingDestinationRect, strctCurrentTrial.m_strctChoicePeriod.m_fRotationAngle);

	fnDrawFixationSpot(g_strctPTB.m_hPTBWindow, strctCurrentTrial.m_strctChoicePeriod, false, 1);
    fChoicesOnsetTS = nan;
end
return;
%}