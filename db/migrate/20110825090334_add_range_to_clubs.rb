class AddRangeToClubs < ActiveRecord::Migration
  def change
    change_table(:clubs) do |t|
      t.integer :range_lower, :range_upper
    end

    data =
      {
        "Chemica"     => 10001..11000,
        "Dentalia"    => 11001..12000,
        "Filologica"  => 12001..14000,
        "GBK"         => 14001..15000,
        "GFK"         => 15001..16000,
        "Geografica"  => 16001..17000,
        "Geologica"   => 17001..18000,
        "Hilok"       => 18001..20000,
        "KMF"         => 20001..21000,
        "KHK"         => 21001..22000,
        "Lombrosiana" => 22001..23000,
        "OAK"         => 23001..24000,
        "Politeia"    => 24001..26000,
        "Slavia"      => 26001..27000,
        "VBK"         => 27001..28000,
        "VDK"         => 28001..30000,
        "VEK"         => 30001..32000,
        "VGK-fgen"    => 32001..34000,
        "VGK-flwi"    => 34001..36000,
        "VLK"         => 36001..38000,
        "VLAK"        => 38001..39000,
        "VPPK"        => 39001..42000,
        "VRG"         => 42001..44000,
        "VTK"         => 44001..46000,
        "Wina"        => 46001..47000
       }

    data.each do |name, range|
      c = Club.find_by_internal_name(name)
      c.range_lower = range.begin
      c.range_upper = range.end
      c.save!
    end
  end
end
