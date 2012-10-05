clear
%% Leemos todos los ficheros de resultados
path = '/opt/bioid/test/res/';
res_files = dir([path '[0-9]*[0-9].res']);

u = 0;
s = 0;
telefono = '';
for i = 1 : numel(res_files)
    
        [scores textdata] = Read_res([path res_files(i).name]);
        % comprobamos si es un usuario nuevo
        if ~isempty(scores)
            if strcmp(telefono,textdata(1,2))
                s = s + 1;
            else
                telefono = textdata(1,2);
                disp (telefono);
                u = u + 1;
                s = 1;
            end
            % Eliminamos el primer dato que esta repetido
%            scores(1) =[];
%            textdata(1,:) = [];
            users(u).sample(s).scores = scores;
            users(u).sample(s).textdata = textdata;
        end
    
end



%% Obtenemos scores genuinos
scores_gen = [];
scores_falsas = [];
for u = 1 : numel(users)
    for s = 1 : numel(users(u).sample)
        scores = users(u).sample(s).scores;
        scores_gen(end+1,1) = u;
        scores_gen(end,2) = s;
        scores_gen(end,3) = scores(u);
        for ou = 1 : numel(scores)
            if (ou~=u)
                scores_falsas(end+1,1) = u;
                scores_falsas(end,2) = ou;
                scores_falsas(end,3) = s;
                scores_falsas(end,4) = scores(ou);
            end
        end
    end
end

%%
save Eva_5muestras

%% Par�metros de Evaluaci�n (Gr�ficas FAR-FRR, ROC, EER, Operating Point)
addpath('./EER_Plot/')
[EER confInterEER OP confInterOP] = EER_DET_conf(scores_gen(:,end),scores_falsas(:,end),1,100,0);
rmpath('./EER_Plot/')
disp (EER);

%% Dibujamos gr�ficas de distribuci�n de similitudes
% for muestras = 3:8
%     clearvars -except v1 muestras
%     load(['Eva_' num2str(muestras) 'muestras.mat'])
%     subplot(3,2,muestras-2)
%     plot_dist(scores_gen(:,end),scores_falsas(:,end),100);
% end
