using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace RewindApp.Entities;

public class Media
{
    public int Id { get; set; }
    [Required]
    public DateTime Date { get; set; }
    [Required]
    public byte[] Photo { get; set; } = Array.Empty<byte>();
    
    [IgnoreDataMember]
    public ICollection<Tag> Tags { get; set; } = new List<Tag>();
    public Group Group { get; set; }
}