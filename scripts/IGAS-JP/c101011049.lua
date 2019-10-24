--グラビティ・コントローラー

--Scripted by mallu11
function c101011049.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101011049.mfilter,1,1)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c101011049.lmlimit)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101011049.indes)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101011049,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(c101011049.tdcon)
	e3:SetTarget(c101011049.tdtg)
	e3:SetOperation(c101011049.tdop)
	c:RegisterEffect(e3)
end
function c101011049.mfilter(c)
	return not c:IsType(TYPE_LINK) and c:GetSequence()>4
end
function c101011049.lmlimit(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetTurnID()==Duel.GetTurnCount()
end
function c101011049.indes(e,c)
	return e:GetHandler():GetSequence()>4 and c:GetSequence()<=4
end
function c101011049.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsControler(1-tp) and tc:GetSequence()>4
end
function c101011049.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if chk==0 then return tc and c:IsAbleToDeck() and tc:IsAbleToDeck() end
	local g=Group.CreateGroup()
	g:AddCard(c)
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c101011049.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local g=Group.CreateGroup()
	if c:IsRelateToBattle() then
		g:AddCard(c)
	end
	if tc and tc:IsRelateToBattle() and tc:IsControler(1-tp) then
		g:AddCard(tc)
	end
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
