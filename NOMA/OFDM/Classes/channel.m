classdef channel
    properties
        Sampling_rate;
        Sampling_time;
        NPaths;
        Velocity_kmh;
        Central_Frequency;
        MaximumDopplerShift;
    end
    methods
        function channel_object = channel()
                    channel_object.Sampling_rate=14*14*15*10^3;
                    channel_object.Sampling_time=1/channel_object.Sampling_rate;
                    channel_object.NPaths=200;
                    channel_object.Velocity_kmh=80;
                    channel_object.Central_Frequency=3.6e9;
                    channel_object.MaximumDopplerShift=channel_object.Velocity_kmh/3.6*channel_object.Central_Frequency/2.998e8;
        end
    end
end