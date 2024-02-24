namespace RewindApp.Requests.ChangeRequests;

public class ChangeProfileImageRequest
{
    public int UserId { get; set; } = default;
    public byte[] Image { get; set; } = Array.Empty<byte>();
}