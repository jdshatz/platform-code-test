require 'award'

class BlueAward
  attr_accessor :quality, :expires_in

  def initialize(quality, expires_in)
    @quality = quality
    @expires_in = expires_in
    @initial_expires_in = @expires_in
    @initial_quality = @quality
  end

  def update_award
  end
end

class Usual < BlueAward
  def update_award
    @expires_in = @initial_expires_in - 1
    return if @initial_quality == 0
    @quality = @initial_quality - 1
    @quality -= 1 if @initial_expires_in < 1
  end
end

class BlueFirst < BlueAward
  def update_award
    @expires_in = @initial_expires_in - 1
    return if @initial_quality >= 50
    @quality = @initial_quality + 1
    @quality += 1 if @initial_expires_in <= 0
    @quality = 50 if @initial_expires_in == 0 && @initial_quality == 49
  end
end

class BlueCompare < BlueAward
  def update_award
    @expires_in = @initial_expires_in - 1
    return @quality = 0 if @initial_expires_in < 1
    return if @initial_quality > 49
    @quality = @initial_quality + 1
    if @initial_expires_in < 6
      @quality += 2
    elsif @initial_expires_in < 11
      @quality += 1  
    end
  end
end

class BlueStar < BlueAward
  def update_award
    @expires_in = @initial_expires_in - 1
    @quality = @initial_quality - 2
    @quality -= 2 if @initial_expires_in < 1
    @quality = 0 if @quality < 0
  end
end

SUPER_CLASS = BlueAward
SUB_CLASSES = {
  'NORMAL ITEM' => Usual, 'Blue First' => BlueFirst,
   'Blue Compare' => BlueCompare, 'Blue Star' => BlueStar
}

def instantiate (award)
  (SUB_CLASSES[award.name] || DEFAULT_CLASS).new(award.quality, award.expires_in)
end

def update_quality(awards)
  awards.each do |award|
    this_award = instantiate(award)
    this_award.update_award
    award.quality = this_award.quality
    award.expires_in = this_award.expires_in
  end
end