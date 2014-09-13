class CombatTest < MiniTest::Test
  def setup
    attacking_area = Winterfell.create_new
    attacking_area.receive!(Footman.create_new(HouseStark))
    defending_area = CastleBlack.create_new
    defending_area.receive!(Footman.create_new(HouseLannister))
    attacking_units = [Footman.create_new(HouseStark)]
    @c = Combat.create_new(attacking_area, defending_area, attacking_units)
  end

  def test_select_house_card
    e = assert_raises(RuntimeError) { @c.select_house_card(StannisBaratheon.new) }
    assert_equal("House Baratheon is not involved in the combat between House Stark and House Lannister", e.message)
    @c.select_house_card(EddardStark.new)
    e = assert_raises(RuntimeError) { @c.select_house_card(RobbStark.new) }
    assert_equal("House Stark has already selected Eddard Stark", e.message)
    @c.select_house_card(TywinLannister.new)
    e = assert_raises(RuntimeError) { @c.select_house_card(SerGregorClegane.new) }
    assert_equal("House Lannister has already selected Tywin Lannister", e.message)
  end
end
