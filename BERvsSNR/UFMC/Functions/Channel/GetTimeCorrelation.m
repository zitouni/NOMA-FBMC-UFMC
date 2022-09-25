      function TimeCorrelation=GetTimeCorrelation(channel_object,spectrum,NSamples)

          Time = -channel_object.Sampling_time*(NSamples-1):channel_object.Sampling_time:channel_object.Sampling_time*(NSamples-1);
          switch spectrum
            case 'Jakes'
                TimeCorrelation = besselj(0,pi*2*channel_object.MaximumDopplerShift*Time); 
            case 'Uniform'
                TimeCorrelation = sinc(2*channel_object.MaximumDopplerShift*Time);
          end
      end