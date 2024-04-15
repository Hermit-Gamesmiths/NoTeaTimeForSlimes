## Notes to We'll Definitely Forget Are Here.

### Activators (in the "scenes/components" directory)

This is a super janky trigger system I threw together. It's not the best XD. Activators always "Act" on their immediate parent in the Node tree. So whatever you want turned on needs to be the parent. (notably useful for the FallingComponent).

- Proximity Activator
    - This one follows Area2D rules, set editable children to set up the collider. I can't have a collider set up by default because then all Proximity Activators end up sharing a hitbox
- Timer Activator
    - Activates traps periodically regardless of situation. You can set 3 times in the exports.
- Contact Activator
    - This one's like the proximity activator except you give it a "Body" export and it activates whenever that body is touched physically by the player.

#### Stuff Activators can activateificate

- Falling Blocks
- Shooty Blocks
- Hidden Spikes

### Falling Blocks

- structure:
    - CharacterBody2D as the base node
        - FallingComponent (this is where you set falling speed)
            - ContactActivator (you MUST set the "body" export equal to your base CharacterBody, sorry)
        - CollisionShape
        - Sprite
        - etc.
- When building a falling block you have to make sure it's sides are at least 1 pixel less than flush with surrounding tiles. Easiest way is to set collider size = 128 * [tiles] - 1
- You can make a falling block fall through terrain by setting it's mask to not include the "Walls" layer. (If you want it to crush the player it may still need the player layer)
- Instead of having a Contact Activator you can use a Proximity Activator and have blocks fall based on where the player is nearby:
    - CharacterBody2D as the base node
        - FallingComponent (this is where you set falling speed)
            - Proximity Activator (Remember to use "Editable Children" to edit the collision shape)
        - CollisionShape
        - Sprite
        - etc.
    - With this you can also stick a "Death" hitbox somewhere in there and make it _extra deadly!_. (actual crushing coming soon(tm))

### Shooty Blocks

- Pretty similar to Falling Blocks 👆
- structure:
    - Base Node (can be any node 2d, probably a static body most o' the time)
        - `ProjectileShooterComponent` (Positioned at the projectile spawn point, Has a "prototype" export that has to be set)
            - Whatever projectile this will shoot (Must be a `Projectile` node, Must be set as the "Projectile Prototype" in the `ProjectileShooterComponent`)
            - Any Activator node (See Falling Blocks)
