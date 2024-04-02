using System.Net;
using System.Net.Mail;

namespace RewindApp.Services;

public interface IEmailSender
{
    void SendEmail(string receiver, string subject, string message);
}
public class EmailSender : IEmailSender
{
    private const string Mail = "noreply@rewindapp.ru";
    private const string Pass = "QN6pppyRLB1Hkfz4zRWU";
    
    public void SendEmail(string receiver, string subject, string body)
    {
        var smtpClient = new SmtpClient("smtp.mail.ru")
        {
            Port = 587,
            Credentials = new NetworkCredential(Mail, Pass),
            EnableSsl = true,
        };

        smtpClient.Send(Mail, receiver, subject, body);
    }
}