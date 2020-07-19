<?php
declare(strict_types=1);

namespace DB;

class Processor
{
    private $dataPath;
    private $configuration;
    private $outputFilePath;

    private $entityTypes = [
        'tables',
        'seeds',
        'fixtures',
        'functions',
    ];

    private $scripts = [];

    private $clientMinMessages = true;

    public function setDataPath(string $dataPath): self
    {
        $this->dataPath = $dataPath;
        return $this;
    }

    public function setConfiguration(array $configuration): self
    {
        $this->configuration = $configuration;
        return $this;
    }

    public function setOutputFilePath(string $outputFilePath): self
    {
        $this->outputFilePath = $outputFilePath;
        return $this;
    }

    public function run(): void
    {
        $this->composeFilesPaths();
        $this->createScript();
    }

    private function composeFilesPaths(): void
    {
        foreach (array_shift($this->configuration) as $data) {
            foreach ($data as $schema => $entities) {
                foreach ($entities as $entity) {
                    $this->createAllTypesOfEntity($schema, $entity);
                }
            }
        }
    }

    private function createAllTypesOfEntity(string $schema, string $entity): void
    {
        $exists = false;
        foreach ($this->entityTypes as $entityType) {
            $scriptPath = "{$schema}/{$entityType}/{$entity}.sql";
            if ($this->scriptExists($scriptPath)) {
                $exists = true;
                $this->scripts[] = $scriptPath;
            }
        }

        if (!$exists) {
            error_log("!!! Undefined entity {$schema}.{$entity}");
            exit(1);
        }
    }

    private function scriptExists(string $scriptPath): bool
    {
        return file_exists("{$this->dataPath}/{$scriptPath}");
    }

    private function createScript(): void
    {
        if (file_exists($this->outputFilePath)) {
            unlink($this->outputFilePath);
        }

        foreach ($this->scripts as $script) {
            `cat {$this->dataPath}/{$script} >> {$this->outputFilePath}`;
            `echo >> {$this->outputFilePath}`;
        }
    }
}
