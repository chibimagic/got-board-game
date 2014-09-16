class CombatTest < MiniTest::Test
  def setup
    attacking_house_class = HouseStark
    defending_house_class = HouseLannister
    attacking_units = [Footman.create_new(HouseStark)]
    @c = Combat.create_new(attacking_house_class, defending_house_class, attacking_units)
  end

  def test_serialize
    original_combat = @c
    stored_combat = @c.serialize.to_json
    restored_combat = Combat.unserialize(JSON.parse(stored_combat))
    assert_equal(original_combat, restored_combat)
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
