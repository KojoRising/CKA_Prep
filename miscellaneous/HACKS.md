# GREP
    
#### Highlight Words
> grep --color=always -e "^" -e "WORD" 

# Kubectl
#### 1) Custom-Columns | Get All
>  k get clusterrolebinding -ocustom-columns=:.subjects[*].name

#### 2) k Explain: 
> k_explain() { k explain $1 --recursive=true | grep "<" }
> k_explain sa
   
      apiVersion   <string>
      automountServiceAccountToken <boolean>
      imagePullSecrets     <[]Object>
         name      <string>
      kind <string>
      metadata     <Object>
         annotations       <map[string]string>
         clusterName       <string>
         creationTimestamp <string>
         deletionGracePeriodSeconds        <integer>
         deletionTimestamp <string>
         finalizers        <[]string>
         generateName      <string>
         generation        <integer>
         labels    <map[string]string>
         managedFields     <[]Object>
            apiVersion     <string>
            fieldsType     <string>
            fieldsV1       <map[string]>
            manager        <string>
            operation      <string>
            time   <string>
         name      <string>
         namespace <string>
         ownerReferences   <[]Object>
            apiVersion     <string>
            blockOwnerDeletion     <boolean>
            controller     <boolean>
            kind   <string>
            name   <string>
            uid    <string>
         resourceVersion   <string>
         selfLink  <string>
         uid       <string>
      secrets      <[]Object>
         apiVersion        <string>
         fieldPath <string>
         kind      <string>
         name      <string>
         namespace <string>
         resourceVersion   <string>
         uid       <string>
