using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform target;
    public float smooth = 4f; // higher = snappier, lower = more lag

    void LateUpdate()
    {
        if (target == null) return;
        Vector3 p = transform.position;
        p.x = Mathf.Lerp(p.x, target.position.x, smooth * Time.deltaTime);
        transform.position = p;
    }
}