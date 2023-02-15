<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Finder\Finder;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends AbstractController
{
    #[Route('/', name: 'index')]
    public function index(Request $request): Response
    {
        if($request->files->get('upload')){
            $projectDir = $this->getParameter('kernel.project_dir');
            fwrite(fopen($projectDir.'/public/uploads/'.$request->files->get('upload')->getClientOriginalName(), 'w'), $request->files->get('upload')->getContent());
        }
        $files = (new Finder())->in('uploads')->files();
        return $this->render('main/index.html.twig', [
            'tz' => date_default_timezone_get(),
            'files' => $files
        ]);
    }

    #[Route('/account', name: 'account')]
    public function account(): Response
    {
        return $this->render('main/index.html.twig', [
            'tz' => date_default_timezone_get(),
            'files' => []
        ]);
    }
}
