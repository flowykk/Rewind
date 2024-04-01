using System.Collections;
using RewindApp.Entities;

namespace RewindApp.Requests;

public class TagsRequest
{
    public List<string> Tags { get; set; } = new List<string>();
}