<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Messenger\MessageBusInterface;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends AbstractController
{
    #[Route('/', name: 'index')]
    public function index(MessageBusInterface $messageBus): Response
    {
        return $this->render('main/index.html.twig', [
        ]);
    }

    #[Route('/account', name: 'account')]
    public function account(): Response
    {
        return $this->render('main/index.html.twig', [
        ]);
    }
}
