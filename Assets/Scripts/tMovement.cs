using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class tMovement : MonoBehaviour
{
    [SerializeField]
    float movementSpeed;

    [SerializeField]
    float rotateSpeed;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        float movement = Input.GetAxis("Vertical");
        float turn = Input.GetAxis("Horizontal");

        transform.Translate(new Vector3(0, 0, -movement) * movementSpeed * Time.deltaTime);

        transform.Rotate(new Vector3(0, turn, 0) * rotateSpeed * Time.deltaTime);

    }
}
