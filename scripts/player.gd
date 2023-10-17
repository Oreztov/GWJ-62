extends CharacterBody2D

var base_speed = 250
var speed = base_speed
var hand = Globals.Resources.EMPTY
var invincible = false

var last_direction = Vector2.ZERO

@export var weapon_carrot: PackedScene

func _ready():
    Globals.player_reference = self
    $HandSprite.play("empty")

func _physics_process(delta):
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction_x = Input.get_axis("move_left", "move_right")
    var direction_y = Input.get_axis("move_up", "move_down")
    var direction = Vector2(direction_x, direction_y).normalized()
    if direction:
        last_direction = direction
        velocity = direction * speed
        # Play walk animation
        $TopPart.play("walk")
        $BottomPart.play("walk")
        if direction.x < 0:
            $TopPart.flip_h = true
            $BottomPart.flip_h = true
        elif direction.x > 0:
            $TopPart.flip_h = false
            $BottomPart.flip_h = false
    else:
        velocity = Vector2.ZERO
        $TopPart.play("idle")
        $BottomPart.play("idle")
    
    move_and_slide()
    
    # Get inventory item inputs
    if Input.is_action_just_pressed("use_carrot") and Globals.inv[Globals.Plants.CARROT] > 0:
        var new_carrot = weapon_carrot.instantiate()
        new_carrot.position = position
        new_carrot.rotation = last_direction.angle()
        get_parent().call_deferred("add_child", new_carrot)
        Globals.inv[Globals.Plants.CARROT] -= 1
        Globals.hud_reference.update_inventory()

func set_hand_item(item):
    hand = item
    match item:
        Globals.Resources.COMPOST:
            $HandSprite.play("compost")
        Globals.Resources.SOUL:
            $HandSprite.play("soul")
        Globals.Resources.WATER:
            $HandSprite.play("water")
        _:
            $HandSprite.play("empty")

func attacked():
    invincible = true
    $Invincibility.start(1.0)


func _on_invincibility_timeout():
    invincible = false


func _on_area_2d_body_entered(body):
    if body.is_in_group("enemies") and invincible == false:
        Globals.hud_reference.sub_hp(20)
        attacked()
