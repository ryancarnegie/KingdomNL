using UnityEngine;

[ExecuteAlways]
[RequireComponent(typeof(SpriteRenderer))]
public class WaterLine : MonoBehaviour
{
    SpriteRenderer sr;

    void LateUpdate()
    {
        if (sr == null) sr = GetComponent<SpriteRenderer>();
        Camera cam = Camera.main;
        if (cam == null || sr.sharedMaterial == null) return;

        float topY = sr.bounds.max.y;
        float viewportY = cam.WorldToViewportPoint(new Vector3(cam.transform.position.x, topY, 0)).y;
        sr.sharedMaterial.SetFloat("_WaterLine", viewportY);
    }
}