using System.Net;
using System.Net.Mail;

namespace RewindApp.Services;

public interface IEmailSender
{
    void SendEmail(string receiver, string subject, string message);
}
public class EmailSender : IEmailSender
{
    public void SendEmail(string receiver, string subject, string body)
    {
        const string mail = "noreply@rewindapp.ru";
        const string pass = "QN6pppyRLB1Hkfz4zRWU";
        
        var smtpClient = new SmtpClient("smtp.mail.ru")
        {
            Port = 587,
            Credentials = new NetworkCredential(mail, pass),
            EnableSsl = true,
        };

        smtpClient.Send(mail, receiver, subject, body);
    }
}