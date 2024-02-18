using System.Diagnostics.Tracing;
using System.Net;
using System.Net.Mail;
using MimeKit;
using System.Net.Sockets;
using MailKit.Security;
using MimeKit.Text;

namespace RewindApp;

public interface IEmailSender
{
    void SendEmailAsync(string email, string subject, string message);
}
public class EmailSender : IEmailSender
{
    public void SendEmailAsync(string email, string subject, string body)
    {
        var mail = "noreply@rewindapp.ru";
        var pass = "QN6pppyRLB1Hkfz4zRWU";
        
        var smtpClient = new SmtpClient("smtp.mail.ru")
        {
            Port = 587,
            Credentials = new NetworkCredential(mail, pass),
            EnableSsl = true,
        };
        smtpClient.Send(mail, email, subject, body);
    }
}