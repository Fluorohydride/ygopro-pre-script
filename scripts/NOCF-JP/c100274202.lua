--CiNo.1000 夢幻虚光神ヌメロニアス・ヌメロニア
--Number Ci1000: Numeronius Numeronia
--Anime Retrain Version by Kohana Sonogami
function c100274202.initial_effect(c)
	--Xyz Summon
	aux.AddXyzProcedure(c,nil,13,5)
	c:EnableReviveLimit()
	--Gains the following effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100274202.condition)
	e1:SetOperation(c100274202.operation)
	c:RegisterEffect(e1)
	--Negate Attack/Gains LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100274202,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100274202.nacon)
	e2:SetCost(c100274202.nacost)
	e2:SetTarget(c100274202.natg)
	e2:SetOperation(c100274202.naop)
	c:RegisterEffect(e2)
end
c100274202.xyz_number=1000
function c100274202.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(100274201)
end
function c100274202.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--100,000 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100274202.atkcon)
	e1:SetValue(100000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Must attack this card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c100274202.effcon)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(c100274202.atklimit)
	c:RegisterEffect(e3)
	--Win Condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c100274202.wincon)
	e4:SetOperation(c100274202.winop)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4)
end
function c100274202.atkcon(e)
	return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer()
end
function c100274202.effcon(e)
	return Duel.GetTurnCount()>=e:GetHandler():GetTurnID()+1
end
function c100274202.atklimit(e,c)
	return c==e:GetHandler()
end
function c100274202.wincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and e:GetHandler():GetBattledGroupCount()==0 and c100274202.effcon(e)
end
function c100274202.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_NUMERONIUS_NUMERONIA=0x21
	Duel.Win(tp,WIN_REASON_NUMERONIUS_NUMERONIA)
end
function c100274202.nacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c100274202.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100274202.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.GetAttacker()
	if chk==0 then return b and b:IsRelateToBattle() and b:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,b:GetAttack())
end
function c100274202.naop(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetAttacker()
	if Duel.NegateAttack() and b and b:IsRelateToBattle() and b:IsFaceup() then
		Duel.Recover(tp,b:GetAttack(),REASON_EFFECT)
	end
end
