<?php

namespace App\Controller;

use JsonException;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;
use Symfony\Component\Mime\Email;
use Symfony\Component\Routing\Annotation\Route;

final class HomeController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(MailerInterface $mailer): Response
    {
        $email = (new Email())
            ->from('hello@example.com')
            ->to('you@example.com')
            ->subject('Time for Symfony Mailer!')
            ->text('Sending emails is fun again!')
            ->html('<p>See Twig integration for better HTML integration!</p>');

        $mailer->send($email);

        return $this->render('home/index.html.twig');
    }

    /**
     * @throws JsonException
     */
    #[Route('/mercure', name: 'app_mercure')]
    public function publish(HubInterface $hub): Response
    {
        $update = new Update(
            'https://localhost/test/1',
            json_encode(['status' => 'Good!'], JSON_THROW_ON_ERROR)
        );

        $hub->publish($update);

        return $this->render('home/mercure.html.twig');
    }
}
