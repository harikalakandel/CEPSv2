function varargout = guiviewtimeseries1D(varargin)
%========================================================================
%     <guiviewtimeseries1D.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
%     This is part of the MATS-Toolkit http://eeganalysis.web.auth.gr/

%========================================================================
% Copyright (C) 2010 by Dimitris Kugiumtzis and Alkiviadis Tsimpiris 
%                       <dkugiu@gen.auth.gr>

%========================================================================
% Version: 1.0

% LICENSE:
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 3 of the License, or
%     any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program. If not, see http://www.gnu.org/licenses/>.

%=========================================================================
% Reference : D. Kugiumtzis and A. Tsimpiris, "Measures of Analysis of Time Series (MATS): 
% 	          A Matlab  Toolkit for Computation of Multiple Measures on Time Series Data Bases",
%             Journal of Statistical Software, in press, 2010

% Link      : http://eeganalysis.web.auth.gr/
%========================================================================= 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiviewtimeseries1D_OpeningFcn, ...
                   'gui_OutputFcn',  @guiviewtimeseries1D_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiviewtimeseries1D is made visible.
function guiviewtimeseries1D_OpeningFcn(hObject, eventdata, handles, varargin)
% Fill in listbox1 with time series names
dat = getappdata(0,'datlist');
handles.current_data = dat;
listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
for i=2:size(dat(:,1),1)
    listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
end
set(handles.listbox1,'String',listdatS,'Value',1)
set(handles.listbox1,'Max',size(dat(:,1),1))
set(handles.popupmenu1,'Value',1)

messageS = sprintf('Three ways to view history diagram of multiple time series:\n 1) "superimposed in one plot": multiple time series superimposed in a single plot.\n 2) "vertically translated in one plot": multiple time series, one below the other and all in a single plot.\n 3) "one subplot per time series": multiple time series, each at a separate subplot, each subplot below the other.');
set(handles.edit1,'String',messageS);

% Choose default command line output for guifreeplot
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guiviewtimeseries1D_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in time series listbox.
function listbox1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton "superimposed in one plot".
function pushbutton1_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
ntimeseries=length(dataindex_selected);
dat = handles.current_data;
plotdat = dat(dataindex_selected,:);

messageS = sprintf('"superimposed in one plot": multiple time series superimposed in a single plot: \n When up to 5 time series are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the time series).');
set(handles.edit1,'String',messageS);

drawtype = get(handles.popupmenu1,'Value');
if drawtype==1
    symbV = str2mat('-k','-c','-r','--k','--c','--r','-.k','-.c','-.r',':k',':c',':r');
elseif drawtype==2
    symbV = str2mat('ok','oc','or','xk','xc','xr','+k','+c','+r','*k','*c','*r');
else
    symbV = str2mat('o-k','o-c','o-r','x--k','x--c','x--r','+-.k','+-.c','+-.r','*:k','*:c','*:r');
end
nsymb = size(symbV,1);

handles.PlotFigure = figure('NumberTitle','Off','Name','Superimposed in one plot',...
    'PaperOrientation','Landscape');
% axes('position',[0.12 0.16 0.60 0.80])
eval(['plot(plotdat{1,2},''',symbV(1,:),''',''Markersize'',5,''linewidth'',1);'])
hold on
for j=2:ntimeseries
    k = mod(j-1,nsymb)+1;
    eval(['plot(plotdat{j,2},''',symbV(k,:),''',''Markersize'',8,''linewidth'',2);'])
end
if ntimeseries<=5
    datlist = sprintf('''%s''',char(plotdat{1,1}));
    for j=2:ntimeseries
        datlist = sprintf('%s,''%s''',datlist,char(plotdat{j,1}));
    end
    eval(['leg = legend(',datlist,',''location'',''Best'');'])
    set(leg,'EdgeColor',[1 1 1])
else
    for j=1:ntimeseries
        k = mod(j-1,nsymb)+1;
        messageS = sprintf('%s ''%s'': %s \n',messageS,symbV(k,:),char(plotdat{j,1}));
    end
    set(handles.edit1,'String',messageS);
end
xlabel('time step t')
ylabel('x(t)')
guidata(hObject, handles);

% --- Executes on button press in pushbutton "vertically translated in one plot".
function pushbutton2_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
ntimeseries=length(dataindex_selected);
dat = handles.current_data;
plotdat = dat(dataindex_selected,:);

xminV = NaN*ones(ntimeseries,1);
xmaxV = NaN*ones(ntimeseries,1);
nV = NaN*ones(ntimeseries,1);
for j=1:ntimeseries
    xminV(j)=min(plotdat{j,2});
    xmaxV(j)=max(plotdat{j,2});
    nV(j) = plotdat{j,3};
end
xmin = min(xminV);
xmax = max(xmaxV);
dmax = xmax - xmin;
nmax = max(nV);
  
messageS = sprintf('"vertically translated in one plot": multiple time series, one below the other and all in a single plot.');
set(handles.edit1,'String',messageS);
drawtype = get(handles.popupmenu1,'Value');
handles.PlotFigure = figure('NumberTitle','Off','Name','Vertically translated in one plot',...
    'PaperOrientation','Landscape');
% axes('position',[0.12 0.16 0.60 0.80])
hold on
fz = get(get(handles.PlotFigure,'CurrentAxes'),'fontsize');
for j=1:ntimeseries
    if drawtype==1
        plot(plotdat{ntimeseries-j+1,2}+(j-1)*dmax-xmin,'-b','linewidth',1)
    elseif drawtype==2
        plot(plotdat{ntimeseries-j+1,2}+(j-1)*dmax-xmin,'.b','Markersize',8)
    else
        plot(plotdat{ntimeseries-j+1,2}+(j-1)*dmax-xmin,'.-b','Markersize',8,'linewidth',1)
    end
    plot([1 nmax],j*dmax*[1 1],'k')
    text(nmax,(j-1)*dmax,plotdat{ntimeseries-j+1,1},'HorizontalAlignment','right','VerticalAlignment','bottom','fontsize',fz-2)
end
ax = axis;
axis([1 nmax 0 dmax*ntimeseries])
set(get(handles.PlotFigure, 'CurrentAxes'), 'YTickLabel', [])
set(get(handles.PlotFigure, 'CurrentAxes'), 'YTick', [])
set(get(handles.PlotFigure, 'CurrentAxes'), 'Box','On')
xlabel('time step t')
ylabel('x(t)')
guidata(hObject, handles);

% --- Executes on button press in pushbutton "subplot per time series".
function pushbutton3_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
ntimeseries=length(dataindex_selected);
dat = handles.current_data;
plotdat = dat(dataindex_selected,:);

xminV = NaN*ones(ntimeseries,1);
xmaxV = NaN*ones(ntimeseries,1);
nV = NaN*ones(ntimeseries,1);
for j=1:ntimeseries
    xminV(j)=min(plotdat{j,2});
    xmaxV(j)=max(plotdat{j,2});
    nV(j) = plotdat{j,3};
end
  
messageS = sprintf('"one subplot per time series": multiple time series, each at a separate subplot, each subplot below the other.');
set(handles.edit1,'String',messageS);
drawtype = get(handles.popupmenu1,'Value');
handles.PlotFigure = figure('NumberTitle','Off','Name','One subplot per time series',...
    'PaperOrientation','Landscape');
fz = get(get(handles.PlotFigure,'CurrentAxes'),'fontsize');
for j=1:ntimeseries
    subplot(ntimeseries,1,j)
    if drawtype==1
        plot(plotdat{ntimeseries-j+1,2},'-b','linewidth',1)
    elseif drawtype==2
        plot(plotdat{ntimeseries-j+1,2},'.b','Markersize',8)
    else
        plot(plotdat{ntimeseries-j+1,2},'.-b','Markersize',8,'linewidth',1)
    end
    if j==1
        fz = get(get(handles.PlotFigure,'CurrentAxes'),'fontsize');
    end
    axis([1 nV(ntimeseries-j+1) xminV(ntimeseries-j+1) xmaxV(ntimeseries-j+1)])
    text(nV(ntimeseries-j+1),xminV(ntimeseries-j+1),plotdat{ntimeseries-j+1,1},'HorizontalAlignment','right','VerticalAlignment','bottom','fontsize',fz-2)
end
% set(get(handles.PlotFigure, 'CurrentAxes'), 'YTickLabel', [])
% set(get(handles.PlotFigure, 'CurrentAxes'), 'YTick', [])
% set(get(handles.PlotFigure, 'CurrentAxes'), 'Box','On')
xlabel('time step t')
ylabel('x(t)')
guidata(hObject, handles);


% --- Executes on button press in pushbutton "Exit".
function pushbutton4_Callback(hObject, eventdata, handles)
delete(guiviewtimeseries1D)

% --- Executes on button press in pushbutton "Help".
function pushbutton5_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewTimeSeries1D.htm'')'])

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


