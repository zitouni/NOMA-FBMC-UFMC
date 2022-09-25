      function ht=GetImpulseResponse(channel_object,DopplerModel,NSamples,PDP)
         IndexDelayTaps = find(PDP');
      
         switch DopplerModel
              case 'Jakes'
                  DopplerShifts = cos(rand([length(IndexDelayTaps) 1 channel_object.NPaths])*2*pi)*channel_object.MaximumDopplerShift;
              case 'Uniform'
                  DopplerShifts = 2*(rand([length(IndexDelayTaps) 1 channel_object.NPaths])-0.5)*channel_object.MaximumDopplerShift;
              otherwise
                  error('Doppler spectrum not supported');
         end

          RandomPhase = rand([length(IndexDelayTaps) 1 channel_object.NPaths]);
          t = 0:channel_object.Sampling_time:channel_object.Sampling_time*(NSamples-1);          
          ht = zeros(length(PDP),NSamples);
          ht(IndexDelayTaps,:) = sum(exp(1j*2*pi*(bsxfun(@plus,RandomPhase,bsxfun(@times,DopplerShifts,t)))),3)./sqrt(channel_object.NPaths);
          PDP_Normalized = PDP.'/sum(PDP);
          ht = bsxfun(@times,sqrt(PDP_Normalized),ht).';
      end