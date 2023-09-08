# Define the bassline pattern
bassline_pattern = "e--f--e--e---e-e--f-"

live_loop :bassline do
    with_synth :dsaw do
  tick
  
  play :e1, release: 0.2 if bassline_pattern.look == "e"
  play :f1, release: 0.2 if bassline_pattern.look == "f"
  
  sleep 0.25
    end 
end


