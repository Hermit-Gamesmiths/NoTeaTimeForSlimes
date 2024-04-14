## Notes to We'll Definitely Forget Are Here.


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
