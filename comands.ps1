#https://learn.microsoft.com/en-us/azure/event-grid/event-schema-aks?tabs=event-grid-event-schema

# Recupera o resource Id de um AKS que já existe como fonte dos eventos, ou seja o publisher
SOURCE_RESOURCE_ID=$(az aks show -g aks-workshop -n aks-workshop --query id --output tsv)

# Cria um hub de eventos como subscriber para os eventos provenientes do AKS
az eventhubs namespace create --location eastus --name AksEventGridNameSpace -g rg-aks-events
az eventhubs eventhub create --name MyEventGridAKSHub --namespace-name AksEventGridNameSpace -g rg-aks-events
ENDPOINT=$(az eventhubs eventhub show -g rg-aks-events -n MyEventGridAKSHub --namespace-name AksEventGridNameSpace --query id --output tsv)

# Aqui se amarra o AKS, no papel de publisher, e o eventhub, no papel de subscriber, criando um eventgrid para essa amarração.
az eventgrid event-subscription create --name MyEventGridAKSSubscription --source-resource-id $SOURCE_RESOURCE_ID --endpoint-type eventhub --endpoint $ENDPOINT

# Verifica se deu tudo certo. 
az eventgrid event-subscription list --source-resource-id $SOURCE_RESOURCE_ID

Exemplo de um evento 
{
    "source": "/subscriptions/3a5e4bfa-fbac-4790-9deb-547b85ce957c/resourceGroups/aks-workshop/providers/Microsoft.ContainerService/managedClusters/aks-workshop",
    "subject": "aks-workshop - teste1",
    "type": "Microsoft.ContainerService.NewKubernetesVersionAvailable",
    "id": "1234567890abcdef1234567890abcdef12345678",
    "data": {
      "latestSupportedKubernetesVersion": "1.20.7",
      "latestStableKubernetesVersion": "1.19.11",
      "lowestMinorKubernetesVersion": "1.18.19",
      "latestPreviewKubernetesVersion": "1.21.1"
    },
    "specversion": "1.0",
    "time": "2021-07-01T04:52:57.0000000Z"
}


