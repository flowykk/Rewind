using System.Net;
using System.Net.Mail;

namespace RewindApp.Services;

public interface IEmailSender
{
    void SendEmail(string email, string subject, string message);
}
public class EmailSender : IEmailSender
{
    public void SendEmail(string recevier, string subject, string body)
    {
        var mail = "noreply@rewindapp.ru";
        var pass = "QN6pppyRLB1Hkfz4zRWU";
        
        var smtpClient = new SmtpClient("smtp.mail.ru")
        {
            Port = 587,
            Credentials = new NetworkCredential(mail, pass),
            EnableSsl = true,
        };

        smtpClient.Send(mail, recevier, subject, body);
    }
}