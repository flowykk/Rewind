namespace RewindApp.Requests.ChangeRequests;

// maybe need to be renamed
public class ChangeProfileImageRequest
{
    public int UserId { get; set; } = default;
    public byte[] Image { get; set; } = Array.Empty<byte>();
}