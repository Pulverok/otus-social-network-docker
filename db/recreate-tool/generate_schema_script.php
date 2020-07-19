<?php

use DB\Processor;
use Symfony\Component\Yaml\Yaml;

require_once __DIR__ . '/vendor/autoload.php';


$dbSchemaDir = __DIR__ . '/../../otus-social-network-db';
$yamlFile = "{$dbSchemaDir}/config.yaml";
$configuration = Yaml::parseFile($yamlFile);
$outputFilePath = __DIR__ . '/../schema/create_schema.sql';

(new Processor())
    ->setConfiguration($configuration)
    ->setDataPath($dbSchemaDir)
    ->setOutputFilePath($outputFilePath)
    ->run();
