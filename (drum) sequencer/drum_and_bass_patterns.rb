# Define the patterns
bassline_pattern = "e--f--e--e---e-e--f-"
kick_pattern = "x-x-"
snare_pattern = "-x-x"
hihat_pattern = "xxxx"

# define samples
kick_drum = :drum_bass_hard
snare_drum = :drum_snare_soft
hihat = :drum_cymbal_pedal

live_loop :bassline do
  with_synth :dsaw do
    tick
    play :e1, release: 0.2, amp: 3 if bassline_pattern.look == "e"
    play :f1, release: 0.2, amp: 3 if bassline_pattern.look == "f"
    
    sleep 0.25
  end
end

live_loop :beat do
  tick
  
  sample kick_drum, attack: 0.02, amp: 0.5 if kick_pattern.look == "x"
  sample snare_drum, attack: 0.02, amp: 0.5 if snare_pattern.look == "x"
  sample hihat, attack: 0.02, amp: 0.5 if hihat_pattern.look == "x"
  
  sleep 0.25
end