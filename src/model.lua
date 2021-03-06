--- Load up network model or initialize from scratch
paths.dofile('models/' .. opt.netType .. '.lua')

-- a path to previously trained model is provided; check whether opt.loadModel is provided such that we can continue from a snapshot
if opt.loadModel ~= 'none' then
    assert(paths.filep(opt.loadModel), 'File not found: ' .. opt.loadModel)
    print('==> Loading model from: ' .. opt.loadModel)
    model = torch.load(opt.loadModel)

-- Or continuing an experiment where it left off
elseif opt.continue or opt.branch ~= 'none' then
    local prevModel = opt.load .. '/final_model.t7'
    print('==> Loading model from: ' .. prevModel)
    model = torch.load(prevModel)

-- Or we're starting fresh
else
    print('==> Creating model from file: models/' .. opt.netType .. '.lua')
    model = createModel(modelArgs)
end

-- Criterion (can be set in the opt.task file as well)
if not criterion then
    criterion = nn[opt.crit .. 'Criterion']()
end

if opt.GPU ~= -1 then
    -- Convert model to CUDA
    print('==> Converting model to CUDA')
    model:cuda()
    criterion:cuda()

    cudnn.fastest = true
    cudnn.benchmark = true
end
