function selected_locations = advanced_gui(horgnum,vergnum)

% Create and hide the GUI figure as it is being constructed.
width = 350;
height= 350;
f = figure('Visible','off','Position',[200,500,width,height]);
hsurf = cell(horgnum,vergnum);

square_width = (width-20)/horgnum;
square_height = (height-20)/vergnum;

% Construct the components
for y = 1:horgnum
    left = 10 + (y-1)*square_width;
    for x = 1:vergnum
        if y == (horgnum+1)/2 && x == (vergnum+1)/2
        else
            bottom = height-10 - x*square_height;
            hsurf{x,y} = uicontrol('Style','togglebutton',...
                'Position',[left,bottom,square_width,square_height],...
                'Callback',{@selectsquare_Callback,x,y});
        end
    end
end

% Initialize the GUI.
% Change units to normalized so components resize
% automatically.
% Assign the GUI a name to appear in the window title.
set(f,'Name','Advanced')
% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');
selected_locations = [];

    function selectsquare_Callback(source,eventdata,x,y)

        button_state = get(source,'Value');
        if button_state == get(source,'Max')
            % toggle button is pressed
            selected_locations = [selected_locations ;[x y]];

        elseif button_state == get(source,'Min')
            % toggle button is not pressed
            numsquares = size(selected_locations,1);
            for i = 1:numsquares
                if sum(selected_locations(i,:) == [x y]) == 2
                    if i ~= 1 && i ~= numsquares
                        selected_locations = [selected_locations(1:(i-1),:);selected_locations((i+1):end,:)];
                    elseif i == 1
                        selected_locations = selected_locations((i+1):end,:);
                    elseif i == numsquares
                        selected_locations = selected_locations(1:(i-1),:);
                    end
                end
            end

        end
    end
end