using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerMove : MonoBehaviour
{
    public float walkSpeed = 3f;
    public float runSpeed = 6f;

    void Update()
    {
        var kb = Keyboard.current;
        if (kb == null) return;

        float dir = 0f;
        if (kb.aKey.isPressed || kb.leftArrowKey.isPressed) dir -= 1f;
        if (kb.dKey.isPressed || kb.rightArrowKey.isPressed) dir += 1f;

        float speed = kb.leftShiftKey.isPressed ? runSpeed : walkSpeed;
        transform.position += Vector3.right * dir * speed * Time.deltaTime;

        if (dir != 0)
            transform.localScale = new Vector3(Mathf.Sign(dir), 1f, 1); // face direction
    }
}