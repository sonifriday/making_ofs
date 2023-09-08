# define patterns
kick_pattern = "x-x-"
snare_pattern = "-x-x"
hihat_pattern = "xxxx"

# define samples
kick_drum = :drum_bass_hard
snare_drum = :drum_snare_soft
hihat = :drum_cymbal_pedal

# loop through the patterns
live_loop :beat do
  tick
  
  sample kick_drum, attack: 0.02 if kick_pattern.look == "x"
  sample snare_drum, attack: 0.02 if snare_pattern.look == "x"
  sample hihat, attack: 0.02 if hihat_pattern.look == "x"
  
  sleep 0.25
end
