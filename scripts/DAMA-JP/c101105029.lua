--Slower Swallow
function c101105029.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c101105029.spcon)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105029,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101105029.cost)
	e2:SetOperation(c101105029.operation)
	c:RegisterEffect(e2)	
	if not c101105029.global_check then
		c101105029.global_check=true
		c101105029[0]={}
		c101105029[1]={}
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetOperation(c101105029.adjustop)
		Duel.RegisterEffect(e2,0)
	end
end
function c101105029.adjustop(e,tp,eg,ep,ev,re,r,rp) 
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			for lv=1,99 do
				c101105029[p][lv]=g:FilterCount(Card.IsLevel,nil,lv)
			end
	end
end
function c101105029.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	for lv=1,99 do 
		if c101105029[tp][lv]>1 then
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>=2
		else
			return false
		end
	end
end
function c101105029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101105029.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetValue(2)
	Duel.RegisterEffect(e1,tp)
end
