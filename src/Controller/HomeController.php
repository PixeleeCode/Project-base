<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mercure\HubInterface;
use Symfony\Component\Mercure\Update;
use Symfony\Component\Routing\Attribute\Route;

final class HomeController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(): Response
    {
        return $this->render('home/index.html.twig', [
            'message' => 'Welcome to your new controller!',
        ]);
    }

    /**
     * @throws \JsonException
     */
    #[Route('/mercure/envoi', name: 'app_mercure_envoi')]
    public function mercure(HubInterface $hub): Response
    {
        $update = new Update(
            'https://localhost/test/1', # URL personnalisée sur laquelle envoyer le message
            json_encode(['status' => 'Good!'], JSON_THROW_ON_ERROR) # Message au format JSON à envoyer sur l'URL du dessus
        );

        $hub->publish($update);

        return $this->render('home/mercure.html.twig');
    }

    #[Route('/mercure/reception', name: 'app_mercure_reception')]
    public function mercureReception(HubInterface $hub): Response
    {
        return $this->render('home/mercure_reception.html.twig');
    }
}
