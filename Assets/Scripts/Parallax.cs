using UnityEngine;

public class Parallax : MonoBehaviour
{
    [Range(0f, 1f)] public float factor = 0.5f; // 0 = moves like the ground, 1 = stays with the camera

    Transform cam;
    Vector3 startPos;
    float camStartX;

    void Start()
    {
        cam = Camera.main.transform;
        startPos = transform.position;
        camStartX = cam.position.x;
    }

    void LateUpdate()
    {
        float dx = cam.position.x - camStartX;
        transform.position = new Vector3(startPos.x + dx * factor, startPos.y, startPos.z);
    }
}