function [ swtMapLabel, labelEquivalences ] = swtlabel( swtMap )
%SWTLABEL Summary of this function goes here
%   Detailed explanation goes here

[m n] = size(swtMap);
swtMapLabel = zeros(m,n);
nextLabel = 1;
labelEquivalences = zeros(100,100);

% Labeling corner pixel located at (1,1)
if swtMap(1,1) ~= Inf
    swtMapLabel(1,1) = 1;
    nextLabel = nextLabel + 1;
end

% Labeling the top row
for y = 2:n
    sw1 = swtMap(1,y);
    sw2 = swtMap(1,y-1);
    if sw1 ~= Inf
        if swtMapLabel(1,y-1) ~= 0 & max(sw1,sw2)/min(sw1,sw2) <= 3
            swtMapLabel(1,y) = swtMapLabel(1,y-1);
        else
            swtMapLabel(1,y) = nextLabel;
            nextLabel = nextLabel + 1;
        end
    end
end

% Labeling the rest of the image
for x = 2:m
    for y = 1:n
        if swtMap(x,y) ~= Inf
            
            wLabel  = swtMapLabel(x,y-1);
            nLabel  = swtMapLabel(x-1,y);
            nwLabel = swtMapLabel(x-1,y-1);
            
            if y > 1
                if nwLabel ~= 0
                    swtMapLabel(x,y) = nwLabel;
                else
                    if wLabel == 0 & nLabel == 0
                        swtMapLabel(x,y) = nextLabel;
                        nextLabel = nextLabel + 1;
                    elseif wLabel ~= 0 & nLabel == 0
                        swtMapLabel(x,y) = wLabel;
                    elseif wLabel == 0 & nLabel ~= 0
                        swtMapLabel(x,y) = nLabel;
                    else
                        % Assign smallest label
                        swtMapLabel(x,y) = min(nLabel,wLabel);
                        
                        sizeNLabel = labelEquivalences(nLabel,1);
                        sizeWLabel = labelEquivalences(wLabel,1);
                        NEquivalences = labelEquivalences(nLabel,2:sizeNLabel+1);
                        WEquivalences = labelEquivalences(wLabel,2:sizeWLabel+1);
                        
                        if isempty(NEquivalences==wLabel)
                            
                            
                            % Add west label to all of north labels
                            % equivalences.
                            for i=1:sizeNLabel
                                iLabel = NEquivalences(i);
                                sizeILabel = labelEquivalences(iLabel,1);
                                
                                labelEquivalences(iLabel,sizeILabel+2) = wLabel;
                                labelEquivalences(iLabel,1) = sizeILabel + 1;
                            end
                            
                            
                            
                            % Add north label to all of west labels
                            % equivalences.
                            for i=1:sizeWLabel
                                iLabel = WEquivalences(i);
                                sizeILabel = labelEquivalences(iLabel,1);
                                
                                labelEquivalences(iLabel,sizeILabel+2) = nLabel;
                                labelEquivalences(iLabel,1) = sizeILabel + 1;
                            end
                            
                        end
                        
                        labelEquivalences(nLabel,sizeNLabel+2) = wLabel;
                        labelEquivalences(wLabel,sizeWLabel+2) = nLabel;
                        labelEquivalences(nLabel,1) = sizeNLabel + 1;
                        labelEquivalences(wLabel,1) = sizeWLabel + 1;
                    end
                end
            else
                if nLabel ~= 0
                    swtMapLabel(x,y) = nLabel;
                else
                    swtMapLabel(x,y) = nextLabel;
                    nextLabel = nextLabel + 1;
                end
            end
        end
    end
end
end

